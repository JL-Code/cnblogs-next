import { BlogClass } from "../model/BlogClass"
import { bufferToString } from "../util/BufferUtil";
import { http } from '@kit.NetworkKit';

const httpRequest = http.createHttp();


@Preview
@Component
export struct BlogView {
  @State blogList: Array<BlogClass> = [];
  @Consume('articlePathStack') articlePathStack: NavPathStack;

  aboutToAppear(): void {
    this.getDataFromHttpRequest()
  }

  getTutorialDataFromJSON() {
    getContext(this).resourceManager.getRawFileContent('BlogData.json').then(value => {
      this.blogList = JSON.parse(bufferToString(value)) as BlogClass[];
    })
  }

  getDataFromHttpRequest() {
    httpRequest.request('https://api.cnblogs.com/api/blogposts/@sitehome', {
      method: http.RequestMethod.GET,
      header: {
        "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IkYyQ0Y5OEU3QTM0NDVGRTU1MkEzOTc5MkUyRDRCQ0M5ODBERTg3NTMiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiI4cy1ZNTZORVgtVlNvNWVTNHRTOHlZRGVoMU0ifQ.eyJuYmYiOjE3MzYwMTE4NTQsImV4cCI6MTczNjAyMjY1NCwiaXNzIjoiaHR0cDovL29wZW5hcGlfb2F1dGgtc2VydmVyIiwiYXVkIjoiQ25CbG9nc0FwaSIsImNsaWVudF9pZCI6Ijg5MzhkMWMxLWJmMmEtNDQyMS05NzhiLTNjMzZhMDM1ZTU4NSIsImp0aSI6IkYxMDY0RTMzQjU5QzE3Mzc1ODMwN0YwNTAzNDUzMDE5IiwiaWF0IjoxNzM2MDExODU0LCJzY29wZSI6WyJDbkJsb2dzQXBpIl19.Gl6Ofw_tMNMmG4QIpNUU-cO_8KZbDzfZLwllko7FNsNx6B9TFeHvXIL_rDR9WzKhd4mHSCoPpAFmD5fZItaD65v_IhmoYH5L2r86ywq3LF0H3ryi9bWHyq404KeNe1Pfp61nQwPpSb8Muovh2_9qe45TA6R966DNfBPz-KxdhpSYfillioweZ1rH61-yo6w86DVm86GeNyobO6wwOcXz9JKnkCGwtbigZS40xUOQ00vTBwZP5BRzCIb8LOCJbTaj3BpZGr2A1dWtCHMrncINQMVjDfFi3WJ4Ct5lPFwWx_HheJIwvolFIeaDqF-I_r1yIGaN1Iac-uk7dRD6lfcFDQ"
      },
      extraData: {
        pageIndex: 1,
        pageSize: 10
      }
    })
      .then(value => {
        if (value.responseCode === http.ResponseCode.OK) {
          this.blogList = JSON.parse(value.result as string) as BlogClass[];
        } else {
          console.error("http fail", JSON.stringify(value))
        }
      })
      .finally(() => {
        httpRequest.destroy()
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
