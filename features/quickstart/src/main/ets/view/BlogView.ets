import { BlogClass } from "../model/BlogClass"
import { bufferToString } from "../util/BufferUtil";

@Preview
@Component
export struct BlogView {
  @State blogList: Array<BlogClass> = [];
  @Consume('articlePathStack') articlePathStack: NavPathStack;

  aboutToAppear(): void {
    this.getTutorialDataFromJSON()
  }

  getTutorialDataFromJSON() {
    getContext(this).resourceManager.getRawFileContent('BlogData.json').then(value => {
      this.blogList = JSON.parse(bufferToString(value)) as BlogClass[];
    })
  }

  build() {
    Column() {
      Text('入门教程')
        .fontColor($r('sys.color.font_primary'))
        .fontSize(16)
        .fontWeight(500)
        .fontFamily('HarmonyHeiTi-medium')
        .textAlign(TextAlign.Start)
        .padding({ left: 16 })
        .margin({ bottom: 8.5 })
      List({ space: 12 }) {
        ForEach(this.blogList, (item: BlogClass) => {
          ListItem() {
            BlogItem({ blogItem: item })
              .onClick(() => {
                this.articlePathStack.pushPathByName('articleDetail', item)
              })
          }
        }, (item: BlogClass) => item.Id.toString())
      }
      .scrollBar(BarState.Off)
      .padding({ left: 16, right: 16 })
    }
    .margin({ top: 18 })
    .alignItems(HorizontalAlign.Start)
  }
}

@Component
struct BlogItem {
  @Prop blogItem: BlogClass

  build() {
    Column({ space: 8 }) {
      // header
      Text(this.blogItem.Title)
        .fontSize(14)
        .fontWeight(700)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      //  body
      Row({ space: 8 }) {
        Image(this.blogItem.Avatar)
          .height(64)
          .width(64)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
        Text(this.blogItem.Description)
          .fontSize(12)
          .layoutWeight(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(4)
      }
      .alignItems(VerticalAlign.Top)

      // footer
      Row() {
        Text(this.blogItem.Author)
          .fontSize(13)
          .fontColor('#4e4099')
        Text(this.blogItem.PostDate)
          .fontSize(13)
          .fontColor(Color.Gray)
        Text(this.blogItem.CommentCount.toString())
          .fontSize(13)
          .fontColor(Color.Gray)
        Text(this.blogItem.DiggCount.toString())
          .fontSize(13)
          .fontColor(Color.Gray)
        Text(this.blogItem.ViewCount.toString())
          .fontSize(13)
          .fontColor(Color.Gray)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .borderRadius(16)
    .backgroundColor(Color.White)
    .padding(12)
    .alignItems(HorizontalAlign.Start)
  }
}
