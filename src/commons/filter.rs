use std::collections::HashMap;

use serde_json::Value;

pub type Filter = Option<HashMap<String, String>>;

pub trait HasFilter
where
    Self: Sized,
{
    // type Error;

    fn filter(vec: Vec<Self>, filter: &Filter) -> Vec<Self> {
        vec.into_iter().filter(Self::predicate(filter)).collect()
    }

    fn predicate(_filter: &Filter) -> Box<dyn FnMut(&Self) -> bool> {
        Box::new(|_| true)
    }

    fn contains(value: &String, search: &String) -> bool {
        value
            .to_lowercase()
            .contains(search.to_lowercase().as_str())
    }

    fn json_contains(json: &Value, key: &str, search: &String) -> bool {
        match json.get(key) {
            Some(value) => Self::contains(&value.to_string(), search),
            None => false,
        }
    }

    // pub fn get_string_from_filter(filter: &Filter, key: &str) -> Result<String, Self::Error> {
    //     get_opt_string_from_filter(filter, key)
    //         .ok_or(PresentationError::Required(format!("filter {}", key)).extend())
    // }

    fn get_opt_string_from_filter(filter: &Filter, key: &str) -> Option<String> {
        if let Some(filter) = filter {
            filter.get(&key.to_string()).map(|v| v.clone())
        } else {
            None
        }
    }
}

// pub fn get_string_from_filter(filter: &Filter, key: &str) -> Result<String, Error> {
//     get_opt_string_from_filter(filter, key)
//         .ok_or(PresentationError::Required(format!("filter {}", key)).extend())
// }

// pub fn get_opt_string_from_filter(filter: &Filter, key: &str) -> Option<String> {
//     if let Some(filter) = filter {
//         filter.get(&key.to_string()).map(|v| v.clone())
//     } else {
//         None
//     }
// }

// pub fn get_opt_json_from_filter(filter: &Filter, key: &str) -> Result<Option<Value>, Error> {
//     match get_opt_string_from_filter(filter, key) {
//         None => Ok(None),
//         Some(value) => serde_json::from_str(value.as_str())
//             .map_err(|error| PresentationError::from(error).extend()),
//     }
// }

// pub fn get_opt_vec_from_filter(filter: &Filter, key: &str) -> Result<Option<Vec<String>>, Error> {
//     match get_opt_string_from_filter(filter, key) {
//         None => Ok(None),
//         Some(value) => match serde_json::from_str(value.as_str()) {
//             Ok(vec) => Ok(Some(vec)),
//             Err(error) => Err(PresentationError::from(error).extend()),
//         },
//     }
// }
