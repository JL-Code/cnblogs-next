import { BlogClass } from "../model/BlogClass"
import { http } from '@kit.NetworkKit';
import { promptAction } from "@kit.ArkUI";
import { PreferencesUtil } from "utils";
import { hilog } from '@kit.PerformanceAnalysisKit';
import dayjs from 'dayjs'

const httpRequest = http.createHttp();
const TAG = 'BlogView';

@Preview
@Component
export struct BlogView {
  @State isRefreshing: boolean = false
  @State hasMoreData: boolean = true
  @State isListReachEnd: boolean = false
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State blogList: Array<BlogClass> = [];
  @Consume('articlePathStack') articlePathStack: NavPathStack;

  aboutToAppear(): void {
    hilog.info(0x0000, TAG, 'aboutToAppear getDataFromHttpRequest')
    this.getDataFromHttpRequest()
  }

  async getDataFromHttpRequest(pullDownRefresh: boolean = true) {
    const tokenInfo = await PreferencesUtil.getToken();
    // 下拉刷新时重置 pageIndex = 1
    if (pullDownRefresh) {
      this.pageIndex = 1;
    } else {
      this.isListReachEnd = true
    }
    httpRequest.request(`https://api.cnblogs.com/api/blogposts/@sitehome?pageIndex=${this.pageIndex}&pageSize=${this.pageSize}`,
      {
        method: http.RequestMethod.GET,
        header: {
          "Authorization": "Bearer " + tokenInfo.access_token
        }
      })
      .then(value => {
        if (value.responseCode === http.ResponseCode.OK) {
          const data = JSON.parse(value.result as string) as BlogClass[];
          // 判断是否还有更多数据
          if (data.length === this.pageSize) {
            this.pageIndex++;
            this.hasMoreData = true;
          } else {
            this.hasMoreData = false;
          }
          if (pullDownRefresh) {
            // 下拉刷新
            this.blogList = data;
          } else {
            // 上拉加载更多
            this.blogList = this.blogList.concat(data)
          }
          hilog.info(0x0000, TAG, "加载完成，获得 %{public}d 条数据", data.length)
        } else {
          hilog.error(0x0000, TAG, "下拉刷新失败：%{public}s", JSON.stringify(value.result))
        }
      })
      .finally(() => {
        this.isRefreshing = false
        this.isListReachEnd = false
      })
  }

  build() {
    Column() {
      // 下拉刷新
      Refresh({ refreshing: $$this.isRefreshing }) {
        List({ space: 12 }) {
          ForEach(this.blogList, (item: BlogClass) => {
            ListItem() {
              BlogItem({ blogItem: item })
                .onClick(() => {
                  this.articlePathStack.pushPathByName('articleDetail', item)
                })
            }
          })
        }
        .scrollBar(BarState.Off)
        .padding({ left: 16, right: 16 })
        // @see https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-rendering-control-foreach-V5#数据源数组项发生变化
        .onReachEnd(() => {
          this.isListReachEnd = true;
        })
        // https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-rendering-control-foreach-V5#数据源数组项发生变化
        .parallelGesture(
          PanGesture({ direction: PanDirection.Up, distance: 80 })
            .onActionStart(() => {
              if (this.isListReachEnd) {
                this.getDataFromHttpRequest(false);
                this.isListReachEnd = false
              }
            })
        )
      }
      .onRefreshing(() => {
        this.getDataFromHttpRequest()
      })
      .refreshOffset(64)
      .pullToRefresh(true)
    }
    .alignItems(HorizontalAlign.Start)
    .padding({ top: 16, bottom: 56 + 16 })
    .backgroundColor('#F1F3F5')
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
        Text(dayjs(this.blogItem.PostDate).format("YYYY-MM-DD HH:mm"))
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
