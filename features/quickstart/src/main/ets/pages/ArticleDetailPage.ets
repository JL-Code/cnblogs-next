import { webview } from "@kit.ArkWeb";
import { HttpUtil } from "utils";
import { BlogClass } from "../model/BlogClass";
import { EditableLeftIconType, EditableTitleBar } from "@kit.ArkUI";

/**
 * WebView与原生应用的连接类
 */
class LinkClass {
  messageFromHtml(value: string) {
    AlertDialog.show({
      message: '来自 html 发送的弹窗消息: ' + value,
      confirm: {
        value: $r('app.string.web_alert_dialog_button_value'),
        action: () => {
          console.log("action")
        }
      },
      cancel: () => {
        console.log("cancel")
      }
    });
  }
}

@Component
export struct ArticleDetailPage {
  @State articleItem: BlogClass | null = null;
  @State linkObj: LinkClass = new LinkClass();
  @Consume('articlePathStack') articlePathStack: NavPathStack;
  private webController: webview.WebviewController = new webview.WebviewController();

  async aboutToAppear(): Promise<void> {
    this.articleItem = this.articlePathStack.getParamByName('articleDetail')[0] as BlogClass;
  }

  removeQuotes(str: string) {
    return str.replace(/^"|"$/g, '');
  }

  build() {
    NavDestination() {
      Column() {
        // 自定义标题栏
        // Column() {
        //   Row() {
        //     Image($r('app.media.ic_back'))
        //       .width(36)
        //     Text(this.articleItem?.Title)
        //       .maxLines(1)
        //   }
        //   .height(56)
        // }
        // .width('60%')
        // .justifyContent(FlexAlign.Start)
        // .alignItems(HorizontalAlign.Start)

        EditableTitleBar({
          title: this.articleItem?.Author,
          leftIconStyle: EditableLeftIconType.Back,
          imageItem: {
            value: this.articleItem!.Avatar,
            isEnabled: true
          },
          isSaveIconRequired: false,
          options: {
            backgroundColor: Color.White
          },
          onCancel: () => {
            this.articlePathStack.pop();
          }
        })
        Web({ src: $rawfile('h5/index.html'), controller: this.webController, })
          .darkMode(WebDarkMode.Auto)
          .javaScriptAccess(true)
          .width('100%')
          .margin({ bottom: 56 })
          .javaScriptProxy({
            object: this.linkObj,
            name: 'linkObj',
            methodList: ['messageFromHtml'],
            controller: this.webController
          })
          .onPageEnd(async () => {
            const body = await HttpUtil.getBlogBody(this.articleItem!.Id)
            this.webController.runJavaScript(`loadData(${body})`)
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .hideTitleBar(true)
  }
}
