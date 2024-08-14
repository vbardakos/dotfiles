use anyhow::{bail, Context, Result};
use std::{
    env, fs,
    io::{self, Write},
    path::{Path, PathBuf},
};

pub fn request<S: Into<String>>(input: S, default: bool) -> Result<bool> {
    let response = match default {
        true => "Y/n",
        false => "y/N",
    };

    print!("{} [{}] ", input.into(), response);
    io::Write::flush(&mut io::stdout())?;
    io::stdout().flush()?;

    let mut buf = String::new();
    let _ = io::stdin().read_line(&mut buf)?;

    match buf.trim().to_lowercase().as_str() {
        "" => Ok(default),
        "y" | "yes" => Ok(true),
        "n" | "no" => Ok(false),
        ss => bail!("unexpected input: {}", ss),
    }
}

pub fn find_common<P: AsRef<Path>>(path: P) -> Result<Vec<PathBuf>> {
    let binding = env::current_exe()?;
    let binding = binding.parent().context("unreachable err")?;
    let cdir = fs::read_dir(binding)?;

    let mut cfg_dirs = Vec::new();
    for path in fs::read_dir(path)? {
        cfg_dirs.push(path?.path())
    }

    let mut common = Vec::new();
    for path in cdir {
        let path = path.unwrap().path();
        if cfg_dirs.contains(&path) {
            common.push(path);
        }
    }
    Ok(common)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_path() -> Result<()> {
        let mut binding = env::current_exe()?;
        for _ in 0..4 {
            binding = binding.parent().unwrap().to_path_buf();
        }
        let paths: Vec<PathBuf> = std::fs::read_dir(binding)?
            .map(|d| d.unwrap().path())
            .collect();

        for path in paths {
            assert!(
                path.ends_with("src")
                    | path.ends_with("Cargo.toml")
                    | path.ends_with("Cargo.lock")
                    | path.ends_with("target")
            );
        }

        Ok(())
    }
}
