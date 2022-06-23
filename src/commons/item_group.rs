pub type VecComparator<T> = Option<Box<dyn Fn(&T, &T) -> bool>>;

pub trait HasId {
    fn id(&self) -> String;
}

pub trait HasItems<I>
where
    I: HasId,
{
    fn get_items_mut(&mut self) -> &mut Vec<I>;

    fn get_item_mut(&mut self, item_id: String) -> Option<&mut I> {
        Self::get_item_from_vec_mut(self.get_items_mut(), item_id)
    }

    fn get_comparator() -> VecComparator<I> {
        None
    }

    fn get_item_from_vec_mut(items: &mut Vec<I>, item_id: String) -> Option<&mut I> {
        for item in items {
            if item.id() == item_id {
                return Some(item);
            }
        }
        None
    }

    fn add_item(&mut self, new_item: I) {
        if let Some(comparator) = Self::get_comparator() {
            insert_to_vec_with_comparator(self.get_items_mut(), new_item, comparator)
        } else {
            self.get_items_mut().push(new_item)
        }
    }

    fn remove_item(&mut self, item_id: String) -> Option<I> {
        Self::remove_item_from_vec(self.get_items_mut(), item_id)
    }

    fn remove_item_from_vec(items: &mut Vec<I>, item_id: String) -> Option<I> {
        let mut i = 0;
        while i < items.len() {
            if items[i].id() == item_id {
                return Some(items.remove(i));
            } else {
                i += 1;
            }
        }
        None
    }
}

pub trait HasNestedGroups<G>
where
    G: HasNestedGroups<G> + HasId,
{
    fn get_groups_mut(&mut self) -> &mut Vec<G>;

    fn get_comparator() -> VecComparator<G> {
        None
    }

    // TODO simplify
    fn add_group(&mut self, new_group: G, parent_group_id: Option<String>) {
        if let Some(parent_id) = parent_group_id {
            if let Some(parent_group) = Self::get_group_mut(self.get_groups_mut(), parent_id) {
                if let Some(comparator) = Self::get_comparator() {
                    insert_to_vec_with_comparator(
                        parent_group.get_groups_mut(),
                        new_group,
                        comparator,
                    )
                } else {
                    parent_group.get_groups_mut().push(new_group);
                }
            }
        } else {
            if let Some(comparator) = Self::get_comparator() {
                insert_to_vec_with_comparator(self.get_groups_mut(), new_group, comparator)
            } else {
                self.get_groups_mut().push(new_group)
            }
        }
    }

    fn get_group_mut<'a>(groups: &'a mut Vec<G>, group_id: String) -> Option<&'a mut G> {
        for group in groups {
            if group.id() == group_id.clone() {
                return Some(group);
            }
            if let Some(nested_group) =
                Self::get_group_mut(group.get_groups_mut(), group_id.clone())
            {
                return Some(nested_group);
            }
        }
        None
    }
}

pub trait HasNestedGroupsWithItems<'a, G, I>
where
    Self: HasNestedGroups<G> + HasItems<I>,
    G: 'a + HasNestedGroups<G> + HasItems<I> + HasId,
    I: 'a + HasId,
{
    fn get_all_items(&mut self) -> Vec<I> {
        let mut all_items = Self::get_items_from_groups(&mut self.get_groups_mut());
        all_items.append(&mut self.get_items_mut());
        all_items
    }

    // This is really bad coded.
    // Ideally it should have a recursive function where we try to get from top items and nested groups' items
    // But we keep hitting "cannot borrow `*group` as mutable more than once at a time"
    fn mutate_item(&'a mut self, item_id: String, apply: &'a mut dyn FnMut(&mut I)) -> bool {
        for item in self.get_items_mut() {
            log::info!("Top level: {:?} {:?}", item_id, item.id());
            if item.id() == item_id.clone() {
                (apply)(item);
                return true;
            }
        }
        for group in self.get_groups_mut() {
            for item in group.get_items_mut() {
                log::info!("Level 1: {:?} {:?}", item_id, item.id());
                if item.id() == item_id.clone() {
                    (apply)(item);
                    return true;
                }
            }
            for nested1 in group.get_groups_mut() {
                for item in nested1.get_items_mut() {
                    log::info!("Level 2: {:?} {:?}", item_id, item.id());
                    if item.id() == item_id.clone() {
                        (apply)(item);
                        return true;
                    }
                }
                for nested2 in nested1.get_groups_mut() {
                    for item in nested2.get_items_mut() {
                        log::info!("Level 3: {:?} {:?}", item_id, item.id());
                        if item.id() == item_id.clone() {
                            (apply)(item);
                            return true;
                        }
                    }
                }
            }
        }
        false
    }

    // fn get_item_from_items(items: &'a mut Vec<I>, item_id: String) -> Option<&'a mut I> {
    //     for item in items {
    //         if item.id() == item_id.clone() {
    //             return Some(item);
    //         }
    //     }
    //     None
    // }

    // fn get_item_from_groups(groups: &'a mut Vec<G>, item_id: String) -> Option<&'a mut I> {
    //     for group in groups {
    //         if let Some(item) = Self::get_item_from_items(group.get_items_mut(), item_id.clone()) {
    //             return Some(item);
    //         }
    //     }
    //     None
    // }

    fn group(&mut self, group_id: String, item_id: String) -> bool {
        if let Some(item) = self.ungroup(item_id) {
            if let Some(group) = Self::get_group_mut(&mut self.get_groups_mut(), group_id) {
                group.add_item(item);
                return true;
            }
        }
        false
    }

    fn ungroup(&mut self, item_id: String) -> Option<I> {
        if let Some(item) = self.remove_item(item_id.clone()) {
            return Some(item);
        }
        for group in self.get_groups_mut() {
            if let Some(item) = Self::ungroup_item_from_group(group, item_id.clone()) {
                return Some(item);
            }
        }
        None
    }

    fn get_items_from_groups(groups: &mut Vec<G>) -> Vec<I> {
        let mut items: Vec<I> = Vec::new();
        for group in groups {
            items.append(&mut group.get_items_mut());
            let mut items_from_groups = Self::get_items_from_groups(&mut group.get_groups_mut());
            items.append(&mut items_from_groups);
        }
        items
    }

    fn ungroup_item_from_group(group: &mut G, item_id: String) -> Option<I> {
        if let Some(item) = group.remove_item(item_id.clone()) {
            return Some(item);
        }
        for nested_group in group.get_groups_mut() {
            if let Some(item) = Self::ungroup_item_from_group(nested_group, item_id.clone()) {
                return Some(item);
            }
        }
        None
    }
}

fn insert_to_vec_with_comparator<T>(
    items: &mut Vec<T>,
    new_item: T,
    comparator: Box<dyn Fn(&T, &T) -> bool>,
) {
    let position = get_position_with_comparator(items, &new_item, comparator);
    items.insert(position, new_item);
}

fn get_position_with_comparator<T>(
    items: &Vec<T>,
    new_item: &T,
    comparator: Box<dyn Fn(&T, &T) -> bool>,
) -> usize {
    let mut position = 0_usize;
    for item in items {
        if (comparator)(&new_item, item) {
            return position;
        }
        position += 1;
    }
    position
}

mod tests {

    use super::{HasId, HasItems, HasNestedGroups, HasNestedGroupsWithItems, VecComparator};

    #[test]
    fn add_items() {
        let mut org = Org::with_board(vec!["John"]);
        org.add_item(Member::new("Jane"));
        org.add_item(Member::new("Alice"));
        assert_eq!(Org::with_board(vec!["Alice", "Jane", "John"]), org);
        assert_eq!(
            vec![
                Member::new("Alice"),
                Member::new("Jane"),
                Member::new("John")
            ],
            org.get_all_items()
        );
        assert!(<Org as HasItems<Member>>::get_comparator().is_some());
    }

    #[test]
    fn remove_item() {
        let mut org = Org::with_board(vec!["Alice", "Jane", "John"]);
        let removed_item = org.remove_item("Alice".to_string());
        assert_eq!(Some(Member::new("Alice")), removed_item);
        assert_eq!(Org::with_board(vec!["Jane", "John"]), org);
    }

    #[test]
    fn get_item_mut() {
        let mut org = Org::with_board(vec!["John", "Jane"]);
        let item = org.get_item_mut("John".to_string());
        assert_eq!(Some(&mut Member::new("John")), item);
    }

    #[test]
    fn add_groups_to_org_unordered() {
        let mut org = Org::with_teams(vec![Team::with_name("Sales")]);
        org.add_group(Team::with_name("Engineering"), None);
        org.add_group(Team::with_name("Backend"), Some("Engineering".to_string()));
        let expected_teams = vec![
            Team::with_name("Sales"),
            Team::with_sub_teams("Engineering", vec![Team::with_name("Backend")]),
        ];
        assert_eq!(expected_teams, org.teams);
        assert!(<Org as HasNestedGroups<Team>>::get_comparator().is_none());
    }

    #[test]
    fn add_groups_to_team_ordered() {
        let mut team = Team::with_name("company");
        team.add_group(Team::with_name("Sales"), None);
        team.add_group(Team::with_name("Engineering"), None);
        team.add_group(Team::with_name("Backend"), Some("Engineering".to_string()));
        let expected_teams = vec![
            Team::with_sub_teams("Engineering", vec![Team::with_name("Backend")]),
            Team::with_name("Sales"),
        ];
        assert_eq!(expected_teams, team.sub_teams);
        assert!(<Team as HasNestedGroups<Team>>::get_comparator().is_some());
    }

    // TODO to deep add item you must add the item in the top Vec<Item> then group it.
    // It would be better to group in a single step
    #[test]
    fn group_deep_item() {
        let mut org = Org::with_teams(vec![Team::with_name("Engineering")]);
        org.add_group(Team::with_name("Backend"), Some("Engineering".to_string()));
        org.add_item(Member::new("Jane"));
        let group_ok = org.group("Backend".to_string(), "Jane".to_string());
        let expected_org = Org::with_teams(vec![Team::with_sub_teams(
            "Engineering",
            vec![Team::with_members("Backend", vec![Member::new("Jane")])],
        )]);
        assert!(group_ok);
        assert_eq!(expected_org, org);
    }

    #[test]
    fn mutate_group_and_deep_item() {
        let mut org = Org::with_teams(vec![Team::with_sub_teams(
            "Engineering",
            vec![Team::new("Backend", vec![Member::new("Jane")], vec![])],
        )]);
        let team = <Org as HasNestedGroups<Team>>::get_group_mut(
            org.get_groups_mut(),
            "Backend".to_string(),
        )
        .unwrap();
        team.name = "DevOps".to_string();

        org.mutate_item("Jane".to_string(), &mut |member| {
            member.name = "Jane Doe".to_string();
        });

        let expected_org = Org::with_teams(vec![Team::with_sub_teams(
            "Engineering",
            vec![Team::new("DevOps", vec![Member::new("Jane Doe")], vec![])],
        )]);
        assert_eq!(expected_org, org);
    }

    #[test]
    fn cant_mutate_deep_item_past_3_group_levels() {
        let mut org = Org::with_teams(vec![Team::with_sub_teams(
            "Engineering",
            vec![Team::with_sub_teams(
                "Backend 1",
                vec![Team::new(
                    "Backend 1.1",
                    vec![Member::new("Jane")],
                    vec![Team::with_members(
                        "Backend 1.1.1",
                        vec![Member::new("John")],
                    )],
                )],
            )],
        )]);
        let sub_team_level_3_member_ok = org.mutate_item("Jane".to_string(), &mut |member| {
            member.name = "Jane Doe".to_string();
        });
        let sub_team_level_4_member_ok = org.mutate_item("John".to_string(), &mut |member| {
            member.name = "John Doe".to_string();
        });
        let sub_team_level_3 = &org.teams[0].sub_teams[0].sub_teams[0];
        let sub_team_level_4 = &org.teams[0].sub_teams[0].sub_teams[0].sub_teams[0];
        assert!(sub_team_level_3_member_ok);
        assert!(!sub_team_level_4_member_ok);
        assert_eq!(Member::new("Jane Doe"), sub_team_level_3.members[0]);
        assert_ne!(Member::new("John Doe"), sub_team_level_4.members[0]);
    }

    #[derive(Clone, Debug, Default, PartialEq)]
    struct Org {
        board: Vec<Member>,
        teams: Vec<Team>,
    }

    #[derive(Clone, Debug, Default, PartialEq)]
    struct Member {
        name: String,
    }

    #[derive(Clone, Debug, Default, PartialEq)]
    struct Team {
        name: String,
        members: Vec<Member>,
        sub_teams: Vec<Team>,
    }

    impl Org {
        #[cfg(test)]
        fn with_board(board_names: Vec<&str>) -> Self {
            Self::new(
                board_names.iter().map(|name| Member::new(name)).collect(),
                vec![],
            )
        }

        #[cfg(test)]
        fn with_teams(teams: Vec<Team>) -> Self {
            Self::new(vec![], teams)
        }

        #[cfg(test)]
        fn new(board: Vec<Member>, teams: Vec<Team>) -> Self {
            Self { board, teams }
        }
    }

    impl Member {
        #[cfg(test)]
        fn new(name: &str) -> Self {
            Self {
                name: name.to_string(),
            }
        }
    }

    impl Team {
        #[cfg(test)]
        fn with_name(name: &str) -> Self {
            Self::with_sub_teams(name, vec![])
        }

        #[cfg(test)]
        fn with_sub_teams(name: &str, sub_teams: Vec<Team>) -> Self {
            Self::new(name, vec![], sub_teams)
        }

        #[cfg(test)]
        fn with_members(name: &str, members: Vec<Member>) -> Self {
            Self::new(name, members, vec![])
        }

        #[cfg(test)]
        fn new(name: &str, members: Vec<Member>, sub_teams: Vec<Team>) -> Self {
            Self {
                name: name.to_string(),
                members,
                sub_teams,
            }
        }
    }

    impl HasId for Member {
        fn id(&self) -> String {
            self.name.clone()
        }
    }

    impl HasId for Team {
        fn id(&self) -> String {
            self.name.clone()
        }
    }

    impl HasItems<Member> for Org {
        fn get_items_mut(&mut self) -> &mut Vec<Member> {
            &mut self.board
        }

        fn get_comparator() -> VecComparator<Member> {
            Some(Box::new(|new, current| new.name < current.name))
        }
    }

    impl HasItems<Member> for Team {
        fn get_items_mut(&mut self) -> &mut Vec<Member> {
            &mut self.members
        }
    }

    impl HasNestedGroups<Team> for Org {
        fn get_groups_mut(&mut self) -> &mut Vec<Team> {
            &mut self.teams
        }
    }

    impl HasNestedGroups<Team> for Team {
        fn get_groups_mut(&mut self) -> &mut Vec<Team> {
            &mut self.sub_teams
        }

        fn get_comparator() -> VecComparator<Team> {
            Some(Box::new(|new, current| new.name < current.name))
        }
    }

    impl<'a> HasNestedGroupsWithItems<'a, Team, Member> for Org {}
}
