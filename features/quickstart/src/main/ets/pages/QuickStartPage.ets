import { router } from '@kit.ArkUI'
import { Banner } from '../view/Banner';
import { BlogView } from '../view/BlogView';

@Component
export struct QuickStartPage {
  @State message: string = '首页'

  build() {
    Column() {
      Text(this.message)
        .fontSize(24)
        .fontWeight(700)
        .width('100%')
        .textAlign(TextAlign.Start)
        .padding({ left: 16 })
        .fontFamily('HarmonyHeiTi-Bold')
        .lineHeight(33)
        .onClick(() => {
          router.back();
        })
      Scroll() {
        Column() {
          Banner()
          BlogView()
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.TopStart)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}
