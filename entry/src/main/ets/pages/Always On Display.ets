import { display } from '@kit.ArkUI';

@Entry
@Component
struct AlwaysOnDisplay {
  @State timeText: string = '';
  @State dateText: string = '';
  @State infoText: string = '';
  private timerId: number = -1;

  aboutToAppear() {
    this.updateTime();
    this.timerId = setInterval(() => {
      this.updateTime();
    }, 1000);

    try {
      const d = display.getDefaultDisplaySync();
      this.infoText = `W:${d.width} H:${d.height}`;
    } catch (e) {
      this.infoText = 'Display info N/A';
    }
  }

  aboutToDisappear() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
    }
  }

  private updateTime() {
    const now = new Date();
    const h = now.getHours().toString().padStart(2, '0');
    const m = now.getMinutes().toString().padStart(2, '0');
    const s = now.getSeconds().toString().padStart(2, '0');

    this.timeText = `${h}:${m}:${s}`;

    const day = now.getDate().toString().padStart(2, '0');
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const year = now.getFullYear();
    this.dateText = `${day}.${month}.${year}`;
  }

  build() {
    Column() {
      Text(this.infoText)
        .fontSize(10)
        .fontColor('#777777')
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ top: 8 })

      Column() {
        Text(this.timeText)
          .fontSize(40)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .textAlign(TextAlign.Center)
          .width('100%')

        Text(this.dateText)
          .fontSize(14)
          .fontColor('#AAAAAA')
          .textAlign(TextAlign.Center)
          .width('100%')
          .margin({ top: 4 })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .layoutWeight(1)

      Text('AOD demo')
        .fontSize(10)
        .fontColor('#555555')
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ bottom: 8 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }
}
