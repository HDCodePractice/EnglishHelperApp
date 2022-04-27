import SwiftUI

struct PictureGameMainView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    
    var body: some View {
        ZStack{
            switch vm.gameStatus{
            case .start:
                PictureGameStartView()
                    .environmentObject(vm)
            case .inProgress:
                Text("In Progress")
                    .onTapGesture {
                        vm.gameStatus = .finish
                    }
            case .finish:
                Text("Finish")
                    .onTapGesture {
                        vm.gameStatus = .start
                    }
            }
        }
        .animation(Animation.easeIn(duration: 1),value: vm.gameStatus)
    }
}

public struct PictureGameView: View {
    public init(){}
    
    public var body: some View {
        PictureGameMainView()
            .environmentObject(PictureGameViewModel())
    }
}

struct PictureGameMainView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PictureGameViewModel(isPreview: true)
        return PictureGameMainView()
            .environmentObject(vm)
    }
}
