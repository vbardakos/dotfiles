use crate::formula::Formula;
use anyhow::{Context, Result};
use std::process::Command;

pub fn brew_exists() -> Result<bool> {
    let output = Command::new("command")
        .args(["-v", "brew"])
        .output()
        .context("Unable to execute command")?;

    Ok(!output.stdout.is_empty())
}

pub fn list_versions<I>(formulae: I) -> Result<Vec<Formula>>
where
    I: IntoIterator<Item = Formula>,
{
    fn get_max_version(formula: Formula) -> Option<Formula> {
        let mut f = formula;
        let output = run(["list", "--versions"]).unwrap();

        for line in output.lines() {
            if let Some((name, vs)) = line.split_once(' ') {
                if f.name == name {
                    let max = vs.split_whitespace().max()?;
                    f.update_state(max);
                    return Some(f);
                }
            }
        }
        None
    }

    #[rustfmt::skip]
    let formulae: Vec<Formula> = formulae
        .into_iter()
        .filter_map(get_max_version)
        .collect();

    Ok(formulae)
}

pub fn install<I>(formulae: I) -> Result<()>
where
    I: IntoIterator<Item = Formula>,
{
    let mut normal = vec!["install".into(), "--no-quarantine".into()];
    let mut casks = normal.clone();
    casks.push("--cask".into());

    for formula in formulae {
        match formula.cask {
            true => casks.push(formula.name),
            false => normal.push(formula.name),
        };
    }

    if normal.len() > 2 {
        run(normal)?;
    }

    if casks.len() > 3 {
        run(casks)?;
    }

    Ok(())
}

fn run<'a, I, S>(args: I) -> Result<String>
where
    I: IntoIterator<Item = S>,
    S: Into<String>,
{
    let args = args.into_iter().map(|s| s.into());

    let output = Command::new("brew")
        .args(args)
        .output()
        .context("Unable to parse argument")?;

    String::from_utf8(output.stdout).context("Output is not UTF")
}

#[cfg(test)]
mod tests {
    use crate::formula::State;

    use super::*;
    #[test]
    fn test_run() -> Result<()> {
        let output = run(["--version"])?;
        if let Some((name, version)) = output.split_once(' ') {
            assert!(name == "Homebrew");
            assert!(!version.is_empty());
        }
        Ok(())
    }

    #[test]
    fn test_list_versions() -> Result<()> {
        let formulae = vec![Formula::new("neovim", "", false)];
        let output = list_versions(formulae)?;

        assert!(output.len() == 1);
        assert!(output[0].name == "neovim");
        assert!(output[0].state == State::Ready);
        Ok(())
    }
}
