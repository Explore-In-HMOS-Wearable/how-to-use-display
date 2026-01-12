import { display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct DisplayInfoPage {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @State widthInfo: number = 0;
  @State heightInfo: number = 0;
  @State refreshRateInfo: number = 0;
  @State orientationInfo: string = '-';
  @State densityInfo: number = 0;
  @State errorMsg: string = '';

  aboutToAppear() {
    this.loadDisplayInfo();
  }

  private loadDisplayInfo() {
    try {
      const defaultDisplay = display.getDefaultDisplaySync();

      this.widthInfo = defaultDisplay.width;
      this.heightInfo = defaultDisplay.height;

      this.refreshRateInfo = (defaultDisplay.refreshRate ?? 0);

      this.densityInfo = (defaultDisplay.densityDPI ?? defaultDisplay.densityDPI ?? 0);

      const o = defaultDisplay.orientation;
      switch (o) {
        case display.Orientation.PORTRAIT:
          this.orientationInfo = 'PORTRAIT';
          break;
        case display.Orientation.LANDSCAPE:
          this.orientationInfo = 'LANDSCAPE';
          break;
        case display.Orientation.PORTRAIT_INVERTED:
          this.orientationInfo = 'PORTRAIT_INVERTED';
          break;
        case display.Orientation.LANDSCAPE_INVERTED:
          this.orientationInfo = 'LANDSCAPE_INVERTED';
          break;
        default:
          this.orientationInfo = `UNKNOWN (${o})`;
      }

      this.errorMsg = '';
    } catch (err) {
      const e = err as BusinessError;
      this.errorMsg = `Display read failed. code=${e.code}`;
      console.error(`Failed to get default display: ${JSON.stringify(e)}`);
    }
  }

  build() {
    Column({ space: 8 }) {
      Text('Display Lab')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ top: 8, bottom: 12 })
      Column({ space: 4 }) {
        Text(`Width: ${this.width} px`)
        Text(`Height: ${this.height} px`)
        Text(`Orientation: ${this.orientationInfo}`)
        Text(`Refresh rate: ${this.refreshRateInfo} Hz`)
        Text(`Density: ${this.densityInfo} dpi`)
      }

      if (this.errorMsg !== '') {
        Text(this.errorMsg)
          .fontSize(12)
          .fontColor(Color.Red)
          .textAlign(TextAlign.Center)
          .width('100%')
          .margin({ top: 6 })
      }
      Column() {
        Image($r('app.media.loading_arrow'))
          .width(20)
          .height(20)
          .onClick(() => {
            this.loadDisplayInfo();
          }).margin({ bottom: 5 })
        Button() {
          Text('Always On Display \n Demo').fontSize(8)
        }
        .backgroundColor(Color.Black)
        .borderColor(Color.White)
        .outlineColor(Color.White)
        .borderWidth(0.5)
        .height(20)
        .padding({ right: 4, left: 4 })
        .onClick(() => {
          this.pageInfos.pushPath({ name: 'AlwaysOnDisplay' });
        })
      }

    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(12)
    .backgroundColor(Color.Black)
  }
}
