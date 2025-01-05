import { BannerClass } from "../model/BannerClass";
import { bufferToString } from "../common/util/BufferUtil";

@Component
export struct Banner {
  @State bannerList: Array<BannerClass> = [];

  // 生命周期函数 hook
  aboutToAppear(): void {
    this.getBannerDataFromJSON();
  }

  getBannerDataFromJSON() {
    getContext(this).resourceManager.getRawFileContent('BannerData.json')
      .then(value => {
        // 获取buffer内容
        // 转换为字符串
        let res: string = bufferToString(value);
        // 解析为数据结构
        this.bannerList = JSON.parse(res) as BannerClass[];
      })
  }

  build() {
    Swiper() {
      ForEach(this.bannerList, (item: BannerClass) => {
        Image($r(item.imageSrc))
          .objectFit(ImageFit.Contain)
          .width('100%')
          .padding({ top: 11, left: 16, right: 16 })
          .borderRadius(16)
      }, (item: BannerClass) => item.id)
    }
    .autoPlay(true)
    .loop(true)
    .indicator(
      new DotIndicator()
        .color('#1a000000')
        .selectedColor('#0A59F7'))
  }
}