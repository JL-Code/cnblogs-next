import { http } from '@kit.NetworkKit';

const baseUrl = "https://api.cnblogs.com";
const accessToken =
  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IkYyQ0Y5OEU3QTM0NDVGRTU1MkEzOTc5MkUyRDRCQ0M5ODBERTg3NTMiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiI4cy1ZNTZORVgtVlNvNWVTNHRTOHlZRGVoMU0ifQ.eyJuYmYiOjE3MzYwMDA1ODksImV4cCI6MTczNjAxMTM4OSwiaXNzIjoiaHR0cDovL29wZW5hcGlfb2F1dGgtc2VydmVyIiwiYXVkIjoiQ25CbG9nc0FwaSIsImNsaWVudF9pZCI6Ijg5MzhkMWMxLWJmMmEtNDQyMS05NzhiLTNjMzZhMDM1ZTU4NSIsImp0aSI6IkExMUY4MDNDNzE4QUZCMTlGM0YyNjhDM0QxQzQ3MTUyIiwiaWF0IjoxNzM2MDAwNTg5LCJzY29wZSI6WyJDbkJsb2dzQXBpIl19.msX__n8EU4Xqwf4t3zSvMKl9DU2A31I92sGQC9uZA9MXIC3iqSZ7mApTLmvI_h9Mfii9ypOlfY-hKJQjkgNoXPi0rKKD1D3iSRe6FMThgqR-ykZDr7-3g19jq6Cs7KJ8eW1L1rsLmWBGiLTHFiIVlaIt7LkovpYsPSUkMu85IzL3_UxniQy2VQKjtpr3c33TUFHsQUTMKNsPrO0Aw-KLRJpWIDUXLvk6FCaGpKhxCe-NVW7RtLGLMnfV43VMQV_jv__ReTGeedo339kceFTowLLl7mBSgUU9GYMQH2X4-TCRpplMtbLq2ivWRPcXlhlEFs74ZVNMmsb3gTza3qywbA"

function buildUrl(api: string) {
  return `${baseUrl}${api}`
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
      "Authorization": accessToken
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
