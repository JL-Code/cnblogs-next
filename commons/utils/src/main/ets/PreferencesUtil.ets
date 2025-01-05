/**
 * 用户首选项工具类
 */
import { preferences } from "@kit.ArkData";
import { hilog } from "@kit.PerformanceAnalysisKit";
import { BusinessError } from "@kit.BasicServicesKit";

const TAG = 'PreferencesUtil';
const KEY_TOKEN = 'token';

export class PreferencesUtil {
  preference?: preferences.Preferences;

  setup(context: Context) {
    this.preference = preferences.getPreferencesSync(context, { name: "PreferencesUtil" })
    hilog.info(0x0000, TAG, 'create success')
  }

  saveToken(token: string) {
    this.preference?.putSync(KEY_TOKEN, token);
    this.preference?.flush(
      (err: BusinessError) => {
        if (err) {
          hilog.error(0x0000, TAG, 'Failed to flush. code =' + err.code + ', message =' + err.message);
          return;
        }
        hilog.info(0x0000, TAG, 'Succeeded in flushing.');
      });
  }

  getToken(): TokenResponse {
    let token: string = '';
    token = this.preference?.getSync(KEY_TOKEN, '{}') as string;
    return JSON.parse(token) as TokenResponse
  }

  isKeyExist(): boolean {
    let isKeyExist: boolean = false;
    this.preference?.has(KEY_TOKEN).then(async (isExist: boolean) => {
      isKeyExist = isExist;
    }).catch((err: Error) => {
      hilog.error(0x0000, TAG, 'Has the value failed with err: ' + err);
    });
    return isKeyExist;
  }
}

export interface TokenResponse {
  access_token: string;
  expires_in: number;
  token_type: string;
  scope: string;
}

export default new PreferencesUtil();