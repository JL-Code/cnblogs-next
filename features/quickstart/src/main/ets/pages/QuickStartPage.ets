import { router } from '@kit.ArkUI'
import { BannerClass } from '../model/BannerClass';
import { BlogClass } from '../model/BlogClass';
import { Banner } from '../view/Banner';
import { BlogView } from '../view/BlogView';
import { ArticleDetailPage } from './ArticleDetailPage';

@Component
export struct QuickStartPage {
  @State message: string = '快速入门'
  @Provide('articlePathStack') articlePathStack: NavPathStack = new NavPathStack();

  @Builder
  quickStartRouter(name: string, param?: BlogClass | BannerClass) {
    if (name === 'articleDetail') {
      ArticleDetailPage()
    }
  }

  build() {
    Navigation(this.articlePathStack) {
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
    .navDestination(this.quickStartRouter)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}
