use corpus::fetch_from_corpus;
use std::env;

fn main() {
    let args_without_arg0 = env::args().skip(1);

    for argument in args_without_arg0 {
        let Some(content) = fetch_from_corpus(argument.as_str()) else {
            println!("Resource not found: {argument}");
            continue;
        };
        println!("{content}");
    }
}
