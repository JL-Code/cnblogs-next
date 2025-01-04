export interface NavBarItemType {
  order: string,
  title: string
}

@Component
export struct NavBarItem {
  @Prop navBarItem: NavBarItemType;
  // 通过@Consume获取到祖代组件传递过来的路由栈数据
  @Consume('knowledgeMapPageStack') knowledgeMapPageStack: NavPathStack;
  // 之所以使用@Link的方式，是由于需要在NavBarItem组件中对值进行修改，并将修改同步到KnowledgeMap组件中。
  @Link currentNavBarIndex: number;

  build() {
    Row() {
      // order
      Text(this.navBarItem.order)
        .margin({ right: 6 })
        .fontFamily('HarmonyHeiTi-Bold')
        .fontSize(21)
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Start)
        .lineHeight(22)
        .fontWeight(700)
      // title
      Text(this.navBarItem.title)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize(16)
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Start)
        .lineHeight(22)
        .fontWeight(500)
      // icon
      Blank()
      Image($r('app.media.ic_arrow'))
        .width(12)
        .height(24)
    }
    .width('100%')
    .height(48)
    .borderRadius(16)
    .alignItems(VerticalAlign.Center)
    .padding({ left: 12, right: 12 })
    .backgroundColor(
      this.currentNavBarIndex === Number(this.navBarItem.order) - 1 ?
        '#1A0A59F7' :
      Color.Transparent
    )
    .onClick(() => {
      const index = Number(this.navBarItem.order) - 1;
      // 点击导航项的时候赋值
      this.currentNavBarIndex = index;
      // replacePath()/replacePathByName()：将当前页面栈栈顶退出，再根据传入参数将对应的NavDestination页面信息入栈。
      this.knowledgeMapPageStack.replacePath({ name: 'KnowledgeMapContent' });
    })
  }
}