Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Scroll UVs" {
	Properties {
		_Color ("Color" , Color) = (0.5,0.5,0.5,1)
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		_ScrollSpeedX ("Scroll Speed in X",Range(0,6)) = 2
		_ScrollSpeedY ("Scroll Speed in Y",Range(0,6)) = 2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _Color;
		sampler2D _MainTex;
		fixed _ScrollSpeedX;
		fixed _ScrollSpeedY;
		
		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed2 scrollUV = IN.uv_MainTex;
			
			fixed valX = _ScrollSpeedX * _Time;
			fixed valY = _ScrollSpeedY * _Time;
			
			scrollUV += fixed2(valX,valY);
		
			float4 c;
			c = tex2D(_MainTex, scrollUV);
			o.Albedo = c.rgb * _Color.rgb;
			o.Alpha = c.a * _Color.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
