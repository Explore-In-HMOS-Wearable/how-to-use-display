import { display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct DisplayInfoPage {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @State width_info: number = 0;
  @State height_info: number = 0;
  @State refresh_rate_info: number = 0;
  @State orientation_info: string = '-';
  @State density_info: number = 0;
  @State errorMsg: string = '';

  aboutToAppear() {
    this.loadDisplayInfo();
  }

  private loadDisplayInfo() {
    try {
      const defaultDisplay = display.getDefaultDisplaySync();

      this.width_info = defaultDisplay.width;
      this.height_info = defaultDisplay.height;

      this.refresh_rate_info = (defaultDisplay.refreshRate ?? 0);

      this.density_info = (defaultDisplay.densityDPI ?? defaultDisplay.densityDPI ?? 0);

      const o = defaultDisplay.orientation;
      switch (o) {
        case display.Orientation.PORTRAIT:
          this.orientation_info = 'PORTRAIT';
          break;
        case display.Orientation.LANDSCAPE:
          this.orientation_info = 'LANDSCAPE';
          break;
        case display.Orientation.PORTRAIT_INVERTED:
          this.orientation_info = 'PORTRAIT_INVERTED';
          break;
        case display.Orientation.LANDSCAPE_INVERTED:
          this.orientation_info = 'LANDSCAPE_INVERTED';
          break;
        default:
          this.orientation_info = `UNKNOWN (${o})`;
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
        Text(`Orientation: ${this.orientation_info}`)
        Text(`Refresh rate: ${this.refresh_rate_info} Hz`)
        Text(`Density: ${this.density_info} dpi`)
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
