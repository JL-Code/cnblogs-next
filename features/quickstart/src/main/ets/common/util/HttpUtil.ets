import { http } from '@kit.NetworkKit';
import { CommonConstants as Const } from '../constant/CommonConstants'
import { PreferencesUtil } from 'utils'

function buildUrl(api: string) {
  return `${Const.API_BASE}${api}`
}

interface ApiProblem {
  title: string;
}

interface PromiseReturn<T> {
  data: T | null,
  error: ApiProblem | null
}

export async function createGet<T>(url: string, options?: http.HttpRequestOptions): Promise<PromiseReturn<T>> {
  const httpRequest = http.createHttp();
  const value: http.HttpResponse = await httpRequest.request(buildUrl(url), {
    method: http.RequestMethod.GET,
    header: {
      "Authorization": ""
    },
    extraData: options?.extraData
  })
  httpRequest.destroy();
  if (value.responseCode === http.ResponseCode.OK) {
    return {
      data: JSON.parse(value.result as string) as T,
      error: null
    };
  } else {
    return {
      data: null,
      error: {
        title: value.result as string
      }
    }
  }
}

export async function getToken<T>(): Promise<PromiseReturn<T>> {
  const httpRequest = http.createHttp();
  const value: http.HttpResponse = await httpRequest.request(buildUrl('/token'), {
    method: http.RequestMethod.POST,
    extraData: {
      client_id: Const.CLIENT_ID,
      client_secret: Const.CLIENT_SECRET,
      grant_type: "client_credentials"
    }
  })
  if (value.responseCode === http.ResponseCode.OK) {
    return {
      data: JSON.parse(value.result as string) as T,
      error: null
    };
  } else {
    return {
      data: null,
      error: {
        title: value.result as string
      }
    }
  }
}
