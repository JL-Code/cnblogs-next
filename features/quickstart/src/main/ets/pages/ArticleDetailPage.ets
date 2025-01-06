import { webview } from "@kit.ArkWeb";
import { HttpUtil } from "utils";
import { BlogClass } from "../model/BlogClass";
import { ComposeTitleBar, EditableLeftIconType, EditableTitleBar, promptAction } from "@kit.ArkUI";

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
        EditableTitleBar({
          title: this.articleItem?.Title,
          imageItem: {
            value: this.articleItem!.Avatar,
            isEnabled: true
          },
          // 设置背景模糊效果
          options: {
            backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
          },
          onCancel: () => {
            this.articlePathStack.pop();
          }
        })
        //定义带头像的标题栏
        // ComposeTitleBar({
        //   title: this.articleItem?.Title,
        //   item: { isEnabled: true, value: this.articleItem!.Avatar }
        // })
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
