Shader "Custom/Shader2" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Overflow("Overflow", Range(0,1)) = 0.5
		_Balance("Balance", Range(0.001, 10)) = 2
	}
	SubShader{
		Tags { 
			//"RenderType" = "Opaque"
			"LightMode" = "ForwardBase"
		}
		LOD 200

		Pass{
			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard fullforwardshadows

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			#pragma vertex vert

			#pragma fragment frag

			//sampler2D _MainTex;

			uniform float4 _Color;
			uniform float4 _LightColor0;
			uniform float1 _Overflow;
			uniform float1 _Balance;

			struct Input {
				//float2 uv_MainTex;
				float4 position: POSITION;
				float4 normal: NORMAL;
			};

			struct Transfer {
				float4 position: SV_POSITION;
				float4 normal: NORMAL;
				float4 color: COLOR;
			};

			Transfer vert(Input IN) {
				Transfer t;
				t.position = IN.position;
				t.position = mul(UNITY_MATRIX_MVP, t.position);
				t.normal = IN.normal;

				float4 lightpos;
				lightpos = mul(_World2Object, _WorldSpaceLightPos0);
				lightpos = normalize(lightpos);

				float1 dotproduct = dot(lightpos, t.normal);

				if (dotproduct < -_Overflow) {
					dotproduct = 0;
				}

				dotproduct = (dotproduct + _Overflow)/(1 + _Overflow);
				//dotproduct = dotproduct * dotproduct;

				t.color = float4(_LightColor0.w * dotproduct * normalize(_Color.xyz * _LightColor0.xyz) / _Balance, 1);

				return t;
			}

			float4 frag(Transfer TRAN) : COLOR{
				return TRAN.color;
			}

			//half _Glossiness;
			//half _Metallic;
			//fixed4 _Color;

			//void surf(Input IN, inout SurfaceOutputStandard o) {
			//	// Albedo comes from a texture tinted by color
			//	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			//	o.Albedo = c.rgb;
			//	// Metallic and smoothness come from slider variables
			//	o.Metallic = _Metallic;
			//	o.Smoothness = _Glossiness;
			//	o.Alpha = c.a;
			//}
			ENDCG
		}

		Tags {
			"LightMode" = "ForwardAdd"
		}

		Pass {
			CGPROGRAM
			#pragma Vertex vert
			#pragma Fragment frag
				struct Input {
				//float2 uv_MainTex;
				float4 position: POSITION;
				float4 normal: NORMAL;
			};

			struct Transfer {
				float4 position: SV_POSITION;
				float4 normal: NORMAL;
				float4 color: COLOR;
			};

			Transfer vert(Input IN) {
				Transfer t;
				t.position = IN.position;
				t.position = mul(UNITY_MATRIX_MVP, t.position);
				t.normal = IN.normal;

				float4 lightpos;
				lightpos = mul(_World2Object, _WorldSpaceLightPos0);
				lightpos = normalize(lightpos);

				float1 dotproduct = dot(lightpos, t.normal);

				if (dotproduct < -_Overflow) {
					dotproduct = 0;
				}

				dotproduct = (dotproduct + _Overflow) / (1 + _Overflow);
				//dotproduct = dotproduct * dotproduct;

				t.color = float4(_LightColor0.w * dotproduct * normalize(_Color.xyz * _LightColor0.xyz) / _Balance, 1);

				return t;
			}

			float4 frag(Transfer TRAN) : COLOR{
				return TRAN.color;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
