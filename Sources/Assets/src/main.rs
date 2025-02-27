use assets::{fetch_from_corpus, list_corpus};
use std::env;

fn main() {
    let args_without_arg0 = env::args().skip(1);

    if args_without_arg0.len() == 0 {
        let args: Vec<_> = env::args().collect();
        let arg0 = &args[0];

        println!("Usage {arg0} + law name");
        println!("Registered laws: ");

        for i in list_corpus() {
            println!(" - {i}");
        }

        return;
    }

    for argument in args_without_arg0 {
        let Some(content) = fetch_from_corpus(argument.as_str()) else {
            println!("Resource not found: {argument}");
            continue;
        };
        println!("{content}");
    }
}
