Shader "Unlit/NewUnlitShader" {

    Properties {                                                // Displayed in the editor
        _MainTex ("Texture", 2D) = "white" {}                   // _Name ("defenition", 2D = "color")
        _NoiseTex ("Noise", 2D) = "white" {}
        _Color ("Color", Color) = (1.000 ,1.000 ,1.000 ,1.000)
        _Value ("Scale", Range(0, 1)) = 0

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

            sampler2D _MainTex;         // sampler2D is used for textures
            sampler2D _NoiseTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _Value;

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
                i.uv.x += _Time.y;
                fixed4 noise = tex2D(_NoiseTex, i.uv);

                if (_Value > noise.r)
                    discard;

                col *= _Color;
                
                i.uv = i.uv * 2 - 1;                                    // Take the length x 2 and subtract the lowest value
                i.uv += sin(_Time.y);                                   // Since its a curve we use sin to get our movement right
                // float v = step(0.900, length(i.uv));                 // Creates a half white and half black circle
                float v = smoothstep(0.900, 0.950, length(i.uv));       // Creates a half white and half black circle
                col = fixed4(v,v,v,1.000);

                return col;
               
                /* 
                || === === === === === === === === === === === === === === === === === || 
                || === === === === === === == Notation === === === === === === === === || 
                || === === === === === === === === === === === === === === === === === || 

                step();                 // Lets us put a "placement" value from o - 1. 0 = 0% of the body, 0.5 = 50% of the body, 0.75 = 75% of the body so on and so forth. 
                smothstep();            // Does exactly the same thing as "step()" but smoother. Like a gradiant. 

                We can make and assign colors like this. 

                fixed3 pos = fixed3(1.000,1.000,1.000);
                fixed4 colOne = v.bbbb;
                fixed3 colTwo = v.bbb;
                fixed3 colThree = v.xyz;

                Examples of how colors can be writen 

                float4 c = _Color.xyzw;
                float4 c = _Color.rgb;
                float4 c = _Color.rrgb;
                float4 c = _Color.abgr;
                float3 c = _Color.bgr;          // Specifick use case for "reverse color".
                float4 c = _Color.rrra;         // Used for one specific color

                We can also use common math such as sin, cos, tan.

                Time.y = time in sec.
                Time.x = time in min.

                i.uv += sin(_Time.y);           // Proper example of how to use math and time
                i.uv += cos(_Time.y);           // Proper example of how to use math and time
                i.uv += tan(_Time.x);           // Proper example of how to use math and time

                || === === === === === === === === === === === === === === === === === ||
                || === === === === === === === === === === === === === === === === === ||
                || === === === === === === === === === === === === === === === === === ||
                */
            }
            ENDCG
        }
    }
}