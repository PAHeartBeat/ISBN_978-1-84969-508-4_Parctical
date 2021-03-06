﻿Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Custom Light (View Direction)
" {
	Properties {
		_EmissiveColor ("Emissive Color" , Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("This is a Slider", float) = 2.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomLightVD

		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;

		struct Input {
			float2 uv_MainTex;
		};
		
	
		inline float4 LightingCustomLightVD (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
			
			/*
			Diffuse light value is calculate in two step when using it with "Lambert" Lighting model
			Step 1. Will get dot procduct (scalar) value of geomatry's normal and lighting direction
			Step 2. will get higher value from 0 and dot product calculated from 1st step.
			*/
			float difLight = max (0, dot(s.Normal, lightDir));

			/*
			RIM light value is calculate by only one step when we using it for Half Lambert
			Step 1. Will get dot procduct (scalar) value of geomatry's normal and view direction of camera
			*/
			float rimLight = dot(s.Normal, viewDir);
	
			
			/*
			_LightColor0.rgb is value provide by unity which contains color of light
			atten is value also retrive from Unity which  intencity of light
			*/
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb  * (difLight * atten * 2 * rimLight);
			
			col.a = s.Alpha;
			return col;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c;
			c = pow((_EmissiveColor + _AmbientColor) , _MySliderValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
