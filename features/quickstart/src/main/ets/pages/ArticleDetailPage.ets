import { webview } from "@kit.ArkWeb";
import { BlogClass } from "../model/BlogClass";

@Component
export struct ArticleDetailPage {
  @State articleDetail: BlogClass | null = null;
  @Consume('articlePathStack') articlePathStack: NavPathStack;

  aboutToAppear(): void {
    this.articleDetail = this.articlePathStack.getParamByName('articleDetail')[0] as BlogClass;
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          // 页面顶栏
          Row() {
            Image($r('app.media.ic_back'))
              .width(40)
              .height(40)
              .onClick(() => {
                this.articlePathStack.pop()
              })
            // 使用 row 包裹 Text 实现文字超长省略效果
            Row() {
              Text(this.articleDetail?.Title)
                .fontFamily('HarmonyHeiTi-Bold')
                .fontSize(20)
                .textAlign(TextAlign.Start)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
                .fontWeight(700)
                .margin({ left: 8 })
            }
          }
          .width('80%')
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height(56)

        WebComponent({ articleDetail: this.articleDetail })
      }
      .padding({ left: 16, right: 16 })
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .hideTitleBar(true)
  }
}

@Component
struct WebComponent {
  @Prop articleDetail: BlogClass | null;
  private webviewController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Web({ src: this.articleDetail?.Url, controller: this.webviewController })
        .darkMode(WebDarkMode.Auto)
        .domStorageAccess(true)
        .zoomAccess(true)
        .fileAccess(true)
        .mixedMode(MixedMode.All)
        .cacheMode(CacheMode.None)
        .javaScriptAccess(true)
        .width('100%')
        .layoutWeight(1)
    }
  }
}