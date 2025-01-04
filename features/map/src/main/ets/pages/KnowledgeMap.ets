import { KnowledgeMapContent, Section } from "../view/KnowledgeMapContent";
import { NavBarItem, NavBarItemType } from "../view/NavBarItem";
import { util } from "@kit.ArkTS";
import { BusinessError } from "@kit.BasicServicesKit";

@Component
export struct KnowledgeMap {
  // 在KnowledgeMap页面中定义路由栈。
  @Provide('knowledgeMapPageStack') knowledgeMapPageStack: NavPathStack = new NavPathStack();
  // 当前路由状态变量currentNavBarIndex，该值默认为-1
  @State currentNavBarIndex: number = -1;

  // 创建NavDestination组件。
  @Builder
  PageMap(name: string) {
    // 向路由子组件传递数据。完成了主页内容的修改后，我们需要将数据传递到内容页中，此处有两种传递方法：
    // 在NavDestination自定义构建函数中，通过组件传参的方式传递数据。
    // 将数据保存到路由栈中，另一侧使用路由栈参数的获取方法取得数据。
    // 此处实现以第一种传递方式为例，向KnowledgeMapContent即知识地图详情页
    if (name === 'KnowledgeMapContent') {
      KnowledgeMapContent({ section: this.sections[this.currentNavBarIndex] });
    }
  }

  @State message: string = '知识地图';
  @State navBarList: NavBarItemType[] = [
    { order: '01', title: '准备与学习' },
    { order: '02', title: '构建应用' },
    { order: '03', title: '应用测试' },
    { order: '04', title: '上架' },
    { order: '05', title: '运营增长' },
    { order: '06', title: '商业变现' },
    { order: '07', title: '更多' }
  ];
  @State sections: Section[] = [];

  private getSections() {
    try {
      getContext(this).resourceManager.getRawFileContent("MapData.json", (error: BusinessError, value: Uint8Array) => {
        const textDecoder = util.TextDecoder.create("utf-8");
        const res = textDecoder.decodeWithStream(value, { stream: false });
        this.sections = JSON.parse(res);
      });
    } catch (error) {
      console.error(`callback getRawFileContent failed, error is ${JSON.stringify(error)}`)
    }
  }

  aboutToAppear(): void {
    this.getSections();
  }

  build() {
    // 绑定路由栈到Navigation组件。=> Navigation(this.knowledgeMapPageStack)
    Navigation(this.knowledgeMapPageStack) {
      Scroll() {
        Column() {
          Text('知识地图')
            .fontFamily('HarmonyHeiTi-Bold')
            .fontSize(24)
            .fontColor(Color.Black)
            .textAlign(TextAlign.Start)
            .lineHeight(33)
            .fontWeight(700)
            .width('100%')
          Image($r('app.media.knowledge_map_banner'))
            .width('100%')
            .borderRadius(16)
            .margin({ top: 19, bottom: 8 })
          Text('通过循序渐进的学习路径，无经验和有经验的开发者都可以轻松掌握ArkTS语言声明式开发范式，体验更简洁、更友好的HarmonyOS应用开发旅程。')
            .fontFamily('HarmonyHeiTi')
            .fontSize(14)
            .fontColor('rgba(0,0,0,0.60)')
            .fontWeight(400)
            .textAlign(TextAlign.Start)
          // list
          List({ space: 12 }) {
            ForEach(this.navBarList, (item: NavBarItemType) => {
              ListItem() {
                NavBarItem({ navBarItem: item, currentNavBarIndex: this.currentNavBarIndex })
              }
              .width('100%')
            }, (item: NavBarItemType): string => item.title)
          }
          .width('100%')
          .margin({ top: 24 })
        }
        .padding({
          top: 12,
          right: 16,
          bottom: 12,
          left: 16
        })
      }
      .backgroundColor('#F1F3F5')
      .align(Alignment.TopStart)
      .constraintSize({ minHeight: '100%' })
      .edgeEffect(EdgeEffect.Spring)

      // 此处添加constraintSize并设置minHeight为100%，可以解决当内容条数不足时，Scroll组件滚动时会出现空白区域的错误效果。
      // edgeEffect用于设置边缘滑动效果，设置为EdgeEffect.Spring表示设置为弹性物理动效。
      // 该效果滑动到边缘后可以根据初始速度或通过触摸事件继续滑动一段距离，松手后回弹。
    }
    .hideTitleBar(true)
    // 关联NavDestination组件与Navigation组件。才能在Navigation组件中使用页面名称的方式来进行组件路由
    .navDestination(this.PageMap)
    // 控制导航栏显示模式,将mode属性设置为NavigationMode.Stack，Navigation组件即可设置为单页面显示模式
    .mode(NavigationMode.Stack)
  }
}