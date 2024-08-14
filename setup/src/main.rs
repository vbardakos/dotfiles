/*
* Required
* neovim ohmyzsh alacritty tmux starship fzf
*
* Aliases
* vim
*/
pub mod brew;
pub mod formula;
pub mod helpers;

use anyhow::Result;
use formula::{Formula, State};
use helpers::request;

fn main() -> Result<()> {
    if !brew::brew_exists()? {
        println!("brew is not installed");
        return Ok(());
    }

    let formulas = [
        Formula::new("neovim", "0.9.5", false),
        Formula::new("tmux", "3.4_1", false),
        Formula::new("starship", "1.18.2", false),
        Formula::new("alacritty", "0.13.2", true),
    ];

    let install: Vec<_> = brew::list_versions(formulas)?
        .into_iter()
        .filter(|f| {
            if f.is_ready() {
                println!("Formula {} is ready", f.name);
                return false;
            }
            println!("Formula {} needs to be installed/updated", f.name);
            return true;
        })
        .collect();

    if !install.is_empty() {
        let response = request("Proceed with the instalation?", true)?;

        if response {
            brew::install(install)?;
        }
    }

    println!("{:?}", std::env::current_exe());

    Ok(())
}
