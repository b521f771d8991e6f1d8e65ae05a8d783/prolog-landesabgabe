#[cfg(test)]
use ctor::ctor;
#[cfg(test)]
use env_logger::Env;
#[cfg(test)]
use log::LevelFilter;

#[cfg(test)]
#[ctor]
fn init_logger() {
    // Only initializes once, before any tests run
    env_logger::Builder::from_env(Env::default().default_filter_or("debug"))
        .format_timestamp_secs()
        .filter_level(LevelFilter::Debug)
        .is_test(true) // silences logger unless a test fails
        .try_init() // ignore “already initialized” errors
        .ok();
}
