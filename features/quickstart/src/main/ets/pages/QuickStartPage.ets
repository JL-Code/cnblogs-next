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
        // 模拟在 AppBar 设置内容
        Row() {
          Text("博客园")
        }
        .justifyContent(FlexAlign.Start)
        .height(60)

        BlogView()
      }
      .width('100%')
      .layoutWeight(1)
    }
    .navDestination(this.quickStartRouter)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}
