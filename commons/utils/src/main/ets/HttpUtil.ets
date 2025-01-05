import { http } from '@kit.NetworkKit';
import { CommonConstants as Const } from './constant/CommonConstants'
import PreferencesUtil from './PreferencesUtil'
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'HttpUtil'

interface ApiProblem {
  title: string;
}

interface PromiseReturn<T> {
  data: T | null,
  error: ApiProblem | null
}

interface ClientCredentialsParam {
  client_id: string
  client_secret: string
  grant_type: 'client_credentials'
}

export class HttpUtil {
  /**
   *
   * @see https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-http-V5#httprequestoptions
   */
  async getAndStoreToken() {
    try {
      const httpRequest = http.createHttp();
      hilog.info(0x0000, TAG, "getAndStoreToken start")
      const value: http.HttpResponse = await httpRequest.request(this.buildUrl('/token'), {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        // 当'content-Type'为'application/x-www-form-urlencoded'时，请求提交的信息主体数据必须在key和value进行URL转码后(encodeURIComponent/encodeURI)，
        // 按照键值对"key1=value1&key2=value2&key3=value3"的方式进行编码，该字段对应的类型通常为String；
        extraData: this.buildFormUrlEncoded({
          client_id: Const.CLIENT_ID,
          client_secret: Const.CLIENT_SECRET,
          grant_type: "client_credentials"
        } as ClientCredentialsParam)
      })
      if (value.responseCode === http.ResponseCode.OK) {
        hilog.info(0x0000, TAG, "getAndStoreToken response %{public}s", value.result)
        PreferencesUtil.saveToken(value.result as string)
      } else {
        hilog.error(0x0000, TAG, "getAndStoreToken error %{public}s", value.result)
      }
    } catch (e) {
      hilog.error(0x0000, TAG, "getAndStoreToken catch error %{public}s", JSON.stringify(e))
    }
  }

  buildUrl(api: string) {
    const url = `${Const.API_BASE}${api}`
    hilog.info(0x0000, TAG, "buildUrl: %{public}s", url)
    return url;
  }

  /**
   * 构建 x-www-form-urlencoded 参数
   * @param data 参数对象
   * @returns key1=value1&key2=value2&key3=value3
   */
  buildFormUrlEncoded(data: object): string {
    let params: string = "";
    Object.keys(data).forEach(k => {
      params += `${k}=${encodeURIComponent(data[k])}&`
    })
    hilog.info(0x0000, TAG, "buildFormUrlEncoded: %{public}s", params)
    return params;
  }
}

export default new HttpUtil();