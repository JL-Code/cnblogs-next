import { webview } from "@kit.ArkWeb";
import { BlogClass } from "../model/BlogClass";

@Component
export struct ArticleDetailPage {
  @State articleDetail: BlogClass | null = null;
  @State body: string = '';
  @Consume('articlePathStack') articlePathStack: NavPathStack;

  async aboutToAppear(): Promise<void> {
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
            }.layoutWeight(1)
          }
          .width('100%')
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height(56)

        WebComponent({ articleId: this.articleDetail?.Id })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .hideTitleBar(true)
  }
}

@Component
struct WebComponent {
  @Prop articleId: number;
  private webviewController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Web({ src: $rawfile('html/index.html'), controller: this.webviewController })
        .darkMode(WebDarkMode.Auto)
        .domStorageAccess(true)
        .zoomAccess(true)
        .fileAccess(true)
        .mixedMode(MixedMode.All)
        .cacheMode(CacheMode.None)
        .javaScriptAccess(true)
        .width('100%')
        .layoutWeight(1)
        .onPageEnd(e => {
          try {
            this.webviewController.runJavaScript(`render(${this.articleId})`)
              .then((result) => {
                console.log('result:' + result)
              })
          } catch (error) {
            console.log('error:' + error)
          }
        })
    }
  }
}