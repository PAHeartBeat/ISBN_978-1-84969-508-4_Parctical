Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/BRDF Ramp Texture " {
	Properties {
		_RampTex ("Ramp Texture",2D) = "white" {}
		_EmissiveColor ("Emissive Color" , Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("This is a Slider", float) = 2.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BRDFRamp

		sampler2D _RampTex;
		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;

		struct Input {
			float2 uv_MainTex;
		};
		
		inline float4 LightingBRDFRamp(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
			
			/*
			RIM light value is calculate by only one step when we using it for Half Lambert
			Step 1. Will get dot procduct (scalar) value of geomatry's normal and lighting direction
			*/
			float difLight =  dot(s.Normal, lightDir);
			
			
			/*
			RIM light value is calculate by only one step when we using it for Half Lambert
			Step 1. Will get dot procduct (scalar) value of geomatry's normal and view direction of camera
			*/
			float rimLight = dot(s.Normal, viewDir);
			
			
			/*
			To get Ramp info on Geomatry we need float2 / vector2 type to as UI of geomatry.
			In custom lighting mode we don't have access of Geomatry value like vertex / UV info, so normaly we can use 
			Lambert base diffuse Light or Half Lambert base diffuse light scalar to maniplate fake UI (as ramp texture effect 
			also fake light effect so we can use it)
			here I used difLight as UV of geomatry and unpack texture info and later we will multiply it with light color
			and Albedo value came form SurfaceOutput
			
			Here we not calculate Half Lambert Light and but caluclate rim light on based of view direction so we will use it to get fake UV of Mesh
			Lambert diffuse light value will use as x and RIM light value will use it as y value
			you can any of value any where cos again we are getting fake lighting usig ramp and view direction
			*/
			float3 ramp = tex2D(_RampTex, float2(difLight,rimLight)).rgb;
			
			/*
			HERE
			_LightColor0.rgb is value provide by unity which contains color of light
			atten is value also retrive from Unity which  intencity of light
			*/
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb  * (ramp);
			
			
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
