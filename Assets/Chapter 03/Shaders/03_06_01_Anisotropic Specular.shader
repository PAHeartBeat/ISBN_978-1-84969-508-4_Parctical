Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Anisotropic Specular" {
	Properties {
		_Color ("Color", Color) = (0.73,0.73,0.73,0.73)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_Gloss ("Glossiness", Range(0.01,1)) = 0.5
		_Shininess ("Shininess", Range(0.01,1)) = 0.5
		_AnsioDir ("Ansiotropic Direction", 2D) = "gray" {}
		_AnsioOffset ("Ansiotropic Offset", float) = -0.2
		//_AnsioPower ("Ansiotropic Power",float) = 100
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf AnsiotropicSpecular

		sampler2D _MainTex;
		sampler2D _AnsioDir;
		
		fixed4 _Color;
		
		fixed _Gloss;
		fixed _Shininess;
		fixed _AnsioOffset;
		fixed _AnsioPower;
		
		struct SurfaceOutputAnsio{
			float3 Albedo;
			float Alpha;
			
			float3 Normal;
			float Specular;
			float Gloss;
			float3 AnsioDir;
			float3 Emission;
		};
		struct Input {
			float2 uv_MainTex;
			float2 uv_AnsioDir;
		};

		inline fixed4 LightingAnsiotropicSpecular (SurfaceOutputAnsio s, fixed3 lightDir, fixed3 viewDir, fixed atten){
			float3 halfVector = normalize(lightDir + viewDir);
			float NdotL = max(0, dot(lightDir, s.Normal));
			float NdotHL = NdotL * 0.5 + 0.5;
			float NdotV = max(0, dot(viewDir, s.Normal));
			
			float HdotA_raw = normalize(s.Normal + s.AnsioDir);
			float HdotA = dot(HdotA_raw, halfVector);
			
			
			float ansio = max(0, sin(radians( (HdotA + _AnsioOffset) * 180 )));
			
			float spec = saturate(pow(ansio,s.Specular * 128) * s.Gloss);
			
			float4 c;
			c.rgb = ((s.Albedo * NdotL * _LightColor0.rgb) + (spec * _SpecColor * _LightColor0.rgb)) * (atten * 2);
			c.a = s.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceOutputAnsio o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed3 ansio = UnpackNormal(tex2D(_AnsioDir,IN.uv_AnsioDir));
			
			o.AnsioDir = ansio;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Specular = _Shininess;
			o.Gloss = _Gloss;
		}
		ENDCG
	} 
	//FallBack "Diffuse"
}
