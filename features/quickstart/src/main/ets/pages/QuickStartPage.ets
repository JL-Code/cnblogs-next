import { BannerClass } from '../model/BannerClass';
import { BlogClass } from '../model/BlogClass';
import { Banner } from '../view/Banner';
import { BlogView } from '../view/BlogView';
import { ArticleDetailPage } from './ArticleDetailPage';

@Component
export struct QuickStartPage {
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
        BlogView()
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
