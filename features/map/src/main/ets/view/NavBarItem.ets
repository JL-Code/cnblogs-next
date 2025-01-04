export interface NavBarItemType {
  order: string,
  title: string
}

@Component
export struct NavBarItem {
  @Prop navBarItem: NavBarItemType;

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
    .backgroundColor('#F1F3F5')
  }
}