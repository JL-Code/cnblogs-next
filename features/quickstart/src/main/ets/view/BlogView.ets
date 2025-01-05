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
  @State isLoadingMore: boolean = false
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
      this.isLoadingMore = true
      this.pageIndex += 1;
    }
    httpRequest.request('https://api.cnblogs.com/api/blogposts/@sitehome', {
      method: http.RequestMethod.GET,
      header: {
        "Authorization": "Bearer " + tokenInfo.access_token
      },
      extraData: {
        pageIndex: this.pageIndex,
        pageSize: this.pageSize
      }
    })
      .then(value => {
        if (value.responseCode === http.ResponseCode.OK) {
          const blogList = JSON.parse(value.result as string) as BlogClass[];
          // 判断是否还有更多数据
          this.hasMoreData = blogList.length > this.pageSize
          if (pullDownRefresh) {
            // 下拉刷新
            this.blogList = blogList;
          } else {
            // 上拉加载更多
            this.blogList = [...this.blogList, ...blogList]
          }
          hilog.info(0x0000, TAG, "加载完成，获得 %{public}d 条数据", blogList.length)
          promptAction.showToast({
            message: '加载完成'
          })
        } else {
          hilog.error(0x0000, TAG, "下拉刷新失败：%{public}s", JSON.stringify(value.result))
        }
      })
      .finally(() => {
        this.isRefreshing = false
        this.isLoadingMore = false
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
          }, (_item: BlogClass, index: number) => index.toString())
        }
        .padding({ left: 16, right: 16 })
        .onReachEnd(() => {
          // 上拉加载更多, onReachEnd 会触发多次，需要做防抖（多次触发仅执行最后一次触发）。
          if (this.isLoadingMore) {
            promptAction.showToast({
              message: '请您休息一会儿，再试'
            })
            return
          }
          if (!this.hasMoreData) {
            promptAction.showToast({
              message: '没有更多数据了'
            })
            return
          }
          promptAction.showToast({
            message: '正在加载更多...'
          })
          this.getDataFromHttpRequest(false);
        })
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        console.info('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onOffsetChange((value: number) => {
        console.info('Refresh onOffsetChange offset:' + value)
      })
      .onRefreshing(() => {
        this.getDataFromHttpRequest()
      })
      .refreshOffset(64)
      .pullToRefresh(true)
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
