/**
 * 用户首选项工具类
 */
import { preferences } from "@kit.ArkData";
import { hilog } from "@kit.PerformanceAnalysisKit";
import { BusinessError } from "@kit.BasicServicesKit";
import HttpUtil from "./HttpUtil";

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

  async getToken(): Promise<TokenResponse> {
    let token: string = '';
    token = this.preference?.getSync(KEY_TOKEN, '{}') as string;
    let tokenInfo = JSON.parse(token) as TokenResponse

    // 令牌过期或无效则重新获取
    if (!tokenInfo.access_token || tokenInfo.expires_in) {
      await HttpUtil.getAndStoreToken()
      token = this.preference?.getSync(KEY_TOKEN, '{}') as string;
      tokenInfo = JSON.parse(token) as TokenResponse
    }

    return tokenInfo;
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