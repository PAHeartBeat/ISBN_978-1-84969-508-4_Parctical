Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Terrin Blend" {
	Properties {
		_Color ("Color" , Color) = (0.5,0.5,0.5,1)
		
		_MLColor ("Main Land Color", Color) = (1,1,1,1)
		_MainTex ("Main Land (RGB)", 2D) = "white" {}
		_MainDirtTex ("Main Dirt (RGB)", 2D) = "white" {}
		
		_SLColor ("Sub Land Color", Color) = (1,1,1,1)
		_SubTex ("Sub Land (RGB)", 2D) = "white" {}
		_SubDirtTex ("Sub Land Dirt (RGB)", 2D) = "white" {}
		
		_BlendTex ("Blending (R=MLc>SLc, G=Ml>Md, B=MlMd>Sl, A=MlMdSl>Sd)", 2D) = "white" {}
	}
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _Color;
		
		fixed4 _MLColor;
		sampler2D _MainTex;
		sampler2D _MainDirtTex;
		
		fixed4 _SLColor;
		sampler2D _SubTex;
		sampler2D _SubDirtTex;
		
		sampler2D _BlendTex;
		
		struct Input {
			float2 uv_MainTex;
			float2 uv_SubTex;
			float2 uv_BlendTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 bTex =  tex2D(_BlendTex, IN.uv_BlendTex);
		
			fixed4 mTex =  tex2D(_MainTex, IN.uv_MainTex);
			fixed4 dTex =  tex2D(_MainDirtTex, IN.uv_MainTex);
			
			fixed4 rTex =  tex2D(_SubTex, IN.uv_SubTex);
			fixed4 rdTex =  tex2D(_SubDirtTex, IN.uv_SubTex);
			
			fixed4 tc = lerp(_SLColor,_MLColor, bTex.r);

			fixed4 fColor;
			fColor = lerp(mTex, dTex, bTex.g);
			fColor = lerp(fColor, rTex, bTex.b);
			fColor = lerp(fColor, rdTex, bTex.a);
			fColor.a = 1;
			
			
			//fColor *= tc;
			fColor = saturate(fColor);
			
			o.Albedo = fColor.rgb * _Color.rgb;
			o.Alpha = fColor.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
