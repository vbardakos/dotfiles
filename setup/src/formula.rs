#[derive(Debug, PartialEq, Clone, Copy, PartialOrd)]
pub enum State {
    Ready,
    Install,
}

#[derive(Debug, PartialEq, PartialOrd, Clone)]
pub struct Formula {
    pub name: String,
    pub cask: bool,
    pub version: String,
    pub state: State,
}

impl Formula {
    pub fn new<S: Into<String>>(name: S, version: S, cask: bool) -> Self {
        Self {
            cask,
            name: name.into(),
            version: version.into(),
            state: State::Install,
        }
    }

    pub fn update_state<S: Into<String>>(&mut self, version: S) -> State {
        let version = version.into();

        if self.version.is_empty() || self.version <= version {
            self.state = State::Ready;
        }
        self.state
    }

    pub fn is_ready(&self) -> bool {
        self.state == State::Ready
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_update() {
        let formula = Formula::new("neovim", "0.1.1", false);

        assert_eq!(formula.clone().update_state("0.2.1"), State::Ready);
        assert_eq!(formula.clone().update_state("0.1.0"), State::Install);
        assert_eq!(formula.clone().update_state("0.1.1"), State::Ready);
    }
}
