import { KnowledgeMap } from 'map'
import { QuickStartPage } from 'quickstart'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { CourseLearning } from 'learning';
import { AddFormMenuItem } from '@kit.ArkUI';
import { formBindingData } from '@kit.FormKit';


const TAG = 'EntryIndex'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  aboutToAppear(): void {
    hilog.info(0x0000, TAG, '%{public}s', 'Index aboutToAppear');
  }

  @Builder
  tabBarBuilder(title: string, targetIndex: number, selectedIcon: Resource, unselectIcon: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedIcon : unselectIcon)
        .width(24)
        .height(24)
      Text(title)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize(10)
        .fontColor(this.currentIndex === targetIndex ? '#0A59F7' : 'rgba(0,0,0,0.60)')
        .textAlign(TextAlign.Center)
        .lineHeight(14)
        .fontWeight(500)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(targetIndex);
    })
  }

  private compId: string = 'jiangliu0316@outlook.com';

  // 构建一个添加到桌面的按钮
  @Builder
  menuBuilder() {
    Menu() {
      AddFormMenuItem(
        {
          bundleName: 'com.atomicservice.6917561638376003485', // 包名
          abilityName: 'EntryFormAbility', // 模块ability名称
          parameters: {
            'ohos.extra.param.key.form_dimension': 2,
            'ohos.extra.param.key.form_name': 'widget',
            'ohos.extra.param.key.module_name': 'entry'
          },
        },
        this.compId,
        {
          formBindingData: formBindingData.createFormBindingData({}),
          // formBindingData: formBindingData.createFormBindingData({ data: 'share' }),
          callback: (error, formId) => {
            hilog.info(0x3900, TAG, `callback info：error = ${JSON.stringify(error)}, formId = ${formId}`);
            if (error?.code === 0) {
              hilog.info(0x3900, TAG, "添加至桌面成功")
            } else {
              hilog.info(0x3900, TAG, "添加至桌面失败，请尝试其它添加方式")
            }
          },
          style: {
            // options: {
            //   startIcon: $r("app.media.icon"), // 菜单图标,可以自己提供。系统默认采用"sys.media.ic_public_add"
            //   content: "添加到桌面", // 菜单内容，可以自己提供。默认使用"sys.string.ohos_add_form_to_desktop"
            // }
          }
        }
      )
    }
  }

  build() {
    Stack() {
      Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
        TabContent() {
          QuickStartPage()
        }
        .tabBar(this.tabBarBuilder('首页', 0, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

        TabContent() {
          CourseLearning()
        }
        .tabBar(this.tabBarBuilder('闪存', 1, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

        TabContent() {
          KnowledgeMap()
        }
        .tabBar(this.tabBarBuilder('我的', 2, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))
      }
      .scrollable(false)
      .vertical(false)
      .divider({
        strokeWidth: 0.5,
        color: '#0D182431'
      })

      Button("按钮")
        .id(this.compId)
        .bindContextMenu(this.menuBuilder(), ResponseType.LongPress, {
          placement: Placement.TopLeft
        })
    }
  }
}