final class SplashBuilder {
    func build() -> SplashViewController {
        let viewModel = SplashViewModel()
        return SplashViewController(viewModel: viewModel)
    }
}
