Shader "Unlit/NewUnlitShader" {

    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1.000 ,1.000 ,1.000 ,1.000)
        _Scale ("Scale", float) = 1.000

    } SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _Scale;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Color;
               
                /*
                fixed3 pos = fixed3(1.000,1.000,1.000);
                fixed4 colOne = v.bbbb;
                fixed3 colTwo = v.bbb;
                fixed3 colThree = v.xyz;
                */

                return col;
            }
            ENDCG
        }
    }
}