import UIKit

final class HeroesListBuilder {
    func build() -> UIViewController {
        let controller = HeroesListViewController(viewModel: HeroesListViewModel())
        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        return navController
    }
}
