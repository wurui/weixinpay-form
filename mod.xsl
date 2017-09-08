<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:oxm="https://www.openxsl.com">
    <xsl:template match="/root" name="wurui.weixinpay-form">
        <!-- className 'J_OXMod' required  -->
        <div class="J_OXMod oxmod-weixinpay-form" ox-mod="weixinpay-form">

            <div class="orderwrap">
                <h3>
                    订单信息
                </h3>
                <table class="order-info" cellpadding="0" cellspacing="0">
                    <tbody>
                        <tr>
                            <th>商品</th>
                            <td>
                                <xsl:value-of select="data/order/title"/>
                            </td>
                        </tr>
                        <tr>
                            <th>金额</th>
                            <td>
                                <b class="price">
                                    <xsl:value-of select="format-number(data/order/totalfee, '0.00')"/>
                                </b>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="wxpaybox">
                <div class="wxpay">
                    <br/>
                    <img src="http://i.oxm1.cc/uploads/git/wurui/img/2ac0s6jloTj7bkv244Ru719A7lm-699.png@!w120"/>
                </div>
                <xsl:choose>
                    <xsl:when test="data/weixinpayform/mweb_url">
                        微信支付调用中...
                        <xsl:if test="env/domain != 'demo'"><!-- 防止在build时跳转走了-->
                            <script>
                                location.href='<xsl:value-of select="data/weixinpayform/mweb_url"/>';
                            </script>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="data/weixinpayform/package !='' ">
                        微信支付调用中...
                        <form name="payform">
                            <xsl:for-each select="data/weixinpayform/*">
                                <input type="hidden" name="{name(.)}" value="{.}"/>
                            </xsl:for-each>
                        </form>
                        <script>
                            var backurl=decodeURIComponent('<xsl:value-of select="q/backurl"/>');
                        </script>
                        <script><![CDATA[
                    var f=document.forms['payform'];
                    var param={
                    "appId":f.appId.value,     //公众号名称，由商户传入
                    "timeStamp":f.timeStamp.value,         //时间戳，自1970年以来的秒数
                    "nonceStr":f.nonceStr.value, //随机串
                    "package":decodeURIComponent(f.package.value),

                    "signType":f.signType.value,         //微信签名方式：
                    "paySign":f.paySign.value //微信签名
                    };
                    function onBridgeReady(){
                        WeixinJSBridge.invoke(
                        'getBrandWCPayRequest', param,
                            function(res){
                                switch(res.err_msg){

                                    case 'get_brand_wcpay_request:ok':

                                    location.href=backurl+'?result=ok'
                                    break
                                    case 'get_brand_wcpay_request:cancel':
                                    location.href=backurl+'?result=cancel'
                                    break
                                    case 'get_brand_wcpay_request:fail':
                                    alert('支付失败:'+res.err_msg)
                                    location.href=backurl+'?result=fail&error='+res.err_msg
                                    break
                                }
                                }

                        );
                    };
                    if (typeof WeixinJSBridge == "undefined"){
                    if( document.addEventListener ){
                    document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
                    }else if (document.attachEvent){
                    document.attachEvent('WeixinJSBridgeReady', onBridgeReady);
                    document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
                    }
                    }else{
                    onBridgeReady();
                    }
                    ]]>
                        </script>

                    </xsl:when>
                    <xsl:otherwise>
                        <h3 class="error">
                            无法支付!
                            <br/>商家未开通微信支付
                        </h3>
                    </xsl:otherwise>
                </xsl:choose>

            </div>

        </div>
    </xsl:template>
</xsl:stylesheet>
