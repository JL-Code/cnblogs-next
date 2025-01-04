import { BlogClass } from "../model/BlogClass"

@Preview
@Component
export struct BlogView {
  @State blogList: Array<BlogClass> = [
    new BlogClass('1', '大语言模型提示技巧（二）－给模型时间思考',
      '在与大语言模型交互的时候，如果模型给出了错误的结论，不要着急否定大模型的能力，我们应当尝试重新构建查询，请求模型在提供它的最终答案之前进行一系列相关的推理。也就是说，如果给模型一个在短时间或用少量文字无法完成的任务，它可能会给出不那么完美甚至是错误的回答。其实这种情况对人类来说也是存在的'
      , $r('app.media.enablement_pic1'),
      '光头颜',
      '2025-1-4 10:49',
      0,
      10,
      109
    ),
    new BlogClass('2', '大语言模型提示技巧（二）－给模型时间思考',
      '在与大语言模型交互的时候，如果模型给出了错误的结论，不要着急否定大模型的能力，我们应当尝试重新构建查询，请求模型在提供它的最终答案之前进行一系列相关的推理。也就是说，如果给模型一个在短时间或用少量文字无法完成的任务，它可能会给出不那么完美甚至是错误的回答。其实这种情况对人类来说也是存在的'
      , $r('app.media.enablement_pic1'),
      '光头颜',
      '2025-1-4 10:49',
      0,
      10,
      109
    ),
    new BlogClass('3', '大语言模型提示技巧（二）－给模型时间思考',
      '在与大语言模型交互的时候，如果模型给出了错误的结论，不要着急否定大模型的能力，我们应当尝试重新构建查询，请求模型在提供它的最终答案之前进行一系列相关的推理。也就是说，如果给模型一个在短时间或用少量文字无法完成的任务，它可能会给出不那么完美甚至是错误的回答。其实这种情况对人类来说也是存在的'
      , $r('app.media.enablement_pic1'),
      '光头颜',
      '2025-1-4 10:49',
      0,
      10,
      109
    ),
    new BlogClass('4', '大语言模型提示技巧（二）－给模型时间思考',
      '在与大语言模型交互的时候，如果模型给出了错误的结论，不要着急否定大模型的能力，我们应当尝试重新构建查询，请求模型在提供它的最终答案之前进行一系列相关的推理。也就是说，如果给模型一个在短时间或用少量文字无法完成的任务，它可能会给出不那么完美甚至是错误的回答。其实这种情况对人类来说也是存在的'
      , $r('app.media.enablement_pic1'),
      '光头颜',
      '2025-1-4 10:49',
      0,
      10,
      109
    ),
    new BlogClass('5', '大语言模型提示技巧（二）－给模型时间思考',
      '在与大语言模型交互的时候，如果模型给出了错误的结论，不要着急否定大模型的能力，我们应当尝试重新构建查询，请求模型在提供它的最终答案之前进行一系列相关的推理。也就是说，如果给模型一个在短时间或用少量文字无法完成的任务，它可能会给出不那么完美甚至是错误的回答。其实这种情况对人类来说也是存在的'
      , $r('app.media.enablement_pic1'),
      '光头颜',
      '2025-1-4 10:49',
      0,
      10,
      109
    ), new BlogClass('6', '大语言模型提示技巧（二）－给模型时间思考',
    '在与大语言模型交互的时候，如果模型给出了错误的结论，不要着急否定大模型的能力，我们应当尝试重新构建查询，请求模型在提供它的最终答案之前进行一系列相关的推理。也就是说，如果给模型一个在短时间或用少量文字无法完成的任务，它可能会给出不那么完美甚至是错误的回答。其实这种情况对人类来说也是存在的'
    , $r('app.media.enablement_pic1'),
    '光头颜',
    '2025-1-4 10:49',
    0,
    10,
    109
  )
  ]

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
          }
        }, (item: BlogClass) => item.id)
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
      Text(this.blogItem.title)
        .fontSize(14)
        .fontWeight(700)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      //  body
      Row({ space: 8 }) {
        Image(this.blogItem.img)
          .height(64)
          .width(64)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
        Text(this.blogItem.summary)
          .fontSize(12)
          .layoutWeight(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(4)
      }
      .alignItems(VerticalAlign.Top)

      // footer
      Row() {
        Text(this.blogItem.author)
          .fontSize(13)
          .fontColor('#4e4099')
        Text(this.blogItem.createdAt)
          .fontSize(13)
          .fontColor(Color.Gray)
        Text(this.blogItem.commentCount.toString())
          .fontSize(13)
          .fontColor(Color.Gray)
        Text(this.blogItem.likeCount.toString())
          .fontSize(13)
          .fontColor(Color.Gray)
        Text(this.blogItem.viewCount.toString())
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
