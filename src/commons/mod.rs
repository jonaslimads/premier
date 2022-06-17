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

    fn get_item_from_vec_mut(items: &mut Vec<I>, item_id: String) -> Option<&mut I> {
        for item in items {
            if item.id() == item_id {
                return Some(item);
            }
        }
        None
    }

    fn add_item(&mut self, item: I) {
        self.get_items_mut().push(item);
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

    fn add_group(&mut self, new_group: G, parent_group_id: Option<String>) {
        let groups = self.get_groups_mut();
        if let Some(parent_id) = parent_group_id {
            if let Some(parent_group) = Self::get_group_mut(groups, parent_id) {
                parent_group.get_groups_mut().push(new_group)
            }
        } else {
            groups.push(new_group)
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
    fn mutate_item(&'a mut self, item_id: String, apply: &'a mut dyn FnMut(&mut I)) {
        for item in self.get_items_mut() {
            log::info!("Top level: {:?} {:?}", item_id, item.id());
            if item.id() == item_id.clone() {
                return (apply)(item);
            }
        }
        for group in self.get_groups_mut() {
            for item in group.get_items_mut() {
                log::info!("Level 1: {:?} {:?}", item_id, item.id());
                if item.id() == item_id.clone() {
                    return (apply)(item);
                }
            }
            for nested1 in group.get_groups_mut() {
                for item in nested1.get_items_mut() {
                    log::info!("Level 2: {:?} {:?}", item_id, item.id());
                    if item.id() == item_id.clone() {
                        return (apply)(item);
                    }
                }
                for nested2 in nested1.get_groups_mut() {
                    for item in nested2.get_items_mut() {
                        log::info!("Level 3: {:?} {:?}", item_id, item.id());
                        if item.id() == item_id.clone() {
                            return (apply)(item);
                        }
                    }
                }
            }
        }
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

    fn group(&mut self, group_id: String, item_id: String) {
        if let Some(item) = self.ungroup(item_id) {
            if let Some(group) = Self::get_group_mut(&mut self.get_groups_mut(), group_id) {
                group.add_item(item);
            }
        }
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
