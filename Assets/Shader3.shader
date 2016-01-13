Shader "Custom/Shader3" {
	Properties{
		_Texture("Texture", 2D) = "white"{}
	}
		SubShader{
			Tags {
				"LightMode" = "Always"
			}
			Pass {
				CGPROGRAM
				ENDCG
			}
	}
}
