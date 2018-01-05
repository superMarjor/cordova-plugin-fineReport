package com.net.ecode.fr;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;

import com.fr.android.activity.IFIntegrationUtils;
import com.fr.android.activity.LoadAppFromURLActivity;
import com.fr.android.platform.utils.http.Callback;
import com.fr.android.utils.FRSDK;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class FineReport extends CordovaPlugin {

    @Override
    protected void pluginInitialize(){
      FRSDK.initSDK(this.cordova.getActivity());
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        JSONObject myJson = args.getJSONObject(0);

        if (action.equals("showFromUrl")) {

            this.showFromUrl(myJson, callbackContext);
            return true;
        }else if(action.equals("logInto")){

            this.logInto(myJson, callbackContext);
            return true;
        }else if (action.equals("isPad")) {

            this.isPad(callbackContext);
            return true;
        }
        return false;
    }

    private void showFromUrl(JSONObject myJson, CallbackContext callbackContext) throws JSONException {
        final String title = myJson.getString("title") ;   // 标题
        final String url = myJson.getString("url") ;       // 报表路径
        String errorMessage = "Invalid value of" ;         // 参数或值无效错误信息

        if (title != null && title.length() > 0 && url != null && url.length() > 0) {
            final Activity _activity = this.cordova.getActivity();

            // 启动activity
            Intent intent = new Intent(Intent.ACTION_MAIN);
            intent.putExtra("title",title);
            intent.putExtra("url",url);
            intent.setClass(_activity, LoadAppFromURLActivity.class);

            _activity.startActivity(intent);
            callbackContext.success("success");
        } else {
            if(title == null || title.length() == 0){
                errorMessage += "[title]" ;
            }
            if(url == null || url.length() == 0){
                errorMessage += "[url]" ;
            }
            callbackContext.error(errorMessage);
        }
    }

    private void logInto(JSONObject myJson, final CallbackContext callbackContext) throws JSONException {
        final String _loginName = myJson.getString("_loginName") ;
        final String _loginPassword = myJson.getString("_loginPassword") ;
        final String _loginIp = myJson.getString("_loginIp") ;

        final Activity _activity = this.cordova.getActivity();

        // 登录决策平台
        IFIntegrationUtils.logInto(_activity,
                _loginIp, _loginName, _loginPassword,
                new Callback<JSONObject>() {
                    @Override
                    public void load(JSONObject jsonObject) {
//                        callbackContext.success("success");
                    }

                    @Override
                    public void loadFail() {
//                        callbackContext.error("fail");
                    }
                });
    }

    private void isPad(CallbackContext callbackContext) throws JSONException {
        JSONObject job = new JSONObject();
        job.put("result",((this.cordova.getActivity().getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE));
        callbackContext.success(job);
    }
}
