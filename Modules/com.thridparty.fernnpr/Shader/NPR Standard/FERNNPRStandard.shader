Shader "FernRender/URP/FERNNPRStandard"
{
    Properties
    {
        [Main(Surface, _, off, off)]
        _group ("Surface", float) = 0
        [Space()]
        [Tex(Surface, _BaseColor)] _BaseMap ("Base Map", 2D) = "white" { }
        [HideInInspector][HDR] _BaseColor ("Base Color", color) = (1, 1, 1, 1)
        [SubToggle(Surface, _NORMALMAP)] _BumpMapKeyword("Use Normal Map", Float) = 0.0
        [Tex(Surface_NORMALMAP)] _BumpMap ("Normal Map", 2D) = "bump" { }
        [Sub(Surface_NORMALMAP)] _BumpScale("Scale", Float) = 1.0
        [Tex(Surface)] _LightMap ("Light Map", 2D) = "white" { }
        [Channel(Surface)] _PBRMetallicChannel("Metallic Channel", Vector) = (1,0,0,0)
        [Sub(Surface)] _Metallic("Metallic", Range(0, 1.0)) = 0.0
        [Channel(Surface)] _PBRSmothnessChannel("Smoothness Channel", Vector) = (0,0,0,1)
        [Sub(Surface)] _Smoothness("Smoothness", Range(0, 1.0)) = 0.5 
        [Channel(Surface)] _PBROcclusionChannel("Occlusion Channel", Vector) = (0,1,0,0)
        [Sub(Surface)] _OcclusionStrength("Occlusion Strength", Range(0, 1.0)) = 0.0
        
        [Main(ShadingMap, _, off, off)]
        _groupShadingMask ("Shading Map", float) = 0
        [Space()]
        [Tex(ShadingMap)] _ShadingMap01 ("Shading Mask Map 1", 2D) = "white" { }

        [Main(Diffuse, _, off, off)]
        _group1 ("DiffuseSettings", float) = 1
        [Space()]
        [KWEnum(Diffuse, CelShading, _CELLSHADING, RampShading, _RAMPSHADING, CellBandsShading, _CELLBANDSHADING, PBRShading, _LAMBERTIAN)] _enum_diffuse ("Shading Mode", float) = 0
        [SubToggle(Diffuse)] _UseHalfLambert ("Use HalfLambert (More Flatter)", float) = 1
        [SubToggle(Diffuse)] _UseRadianceOcclusion ("Radiance Occlusion", float) = 0
        [Sub(Diffuse_LAMBERTIAN._CELLSHADING)] [HDR] _HighColor ("Hight Color", Color) = (1,1,1,1)
        [Sub(Diffuse_LAMBERTIAN._CELLSHADING)] _DarkColor ("Dark Color", Color) = (0.5,0.5,0.5,1)
        [Sub(Diffuse._CELLBANDSHADING)] _CellBands ("Cell Bands(Int)", Range(1, 10)) = 1
        [Sub(Diffuse_CELLSHADING._CELLBANDSHADING)] _CELLThreshold ("Cell Threshold", Range(0.01,1)) = 0.5
        [Sub(Diffuse_CELLSHADING)] _CELLSmoothing ("Cell Smoothing", Range(0.001,1)) = 0.001
        [Sub(Diffuse._CELLBANDSHADING)] _CellBandSoftness ("Cell Softness", Range(0.001, 1)) = 0.001
        [SubToggle(Diffuse._CELLSHADING._LAMBERTIAN,_ADDRAMPSHADING)] _AddRampShading ("Add Ramp Shading", float) = 0
        [Sub(Diffuse_RAMPSHADING._ADDRAMPSHADING)] _DiffuseRampMap ("Ramp Map", 2D) = "white" {}
        [Sub(Diffuse_RAMPSHADING._ADDRAMPSHADING)] _RampMapUOffset ("Ramp Map U Offset", Range(-1,1)) = 0
        [Sub(Diffuse_RAMPSHADING._ADDRAMPSHADING)] _RampMapVOffset ("Ramp Map V Offset", Range(0,1)) = 0.5
        [SubToggle(Diffuse._RAMPSHADING._ADDRAMPSHADING, _USERAMPMAPCHANNEL)] _UseRampMapChannel("Use Ramp Map Channel", Float) = 0.0
        [Channel(Diffuse_USERAMPMAPCHANNEL)] _RampMapVChannel("Ramp Map V Channel", Vector) = (0,0,0,1)
        
        [Main(Specular, _, off, off)]
        _groupSpecular ("SpecularSettings", float) = 1
        [Space()]
        [KWEnum(Specular, None, _, PBR_GGX, _GGX, Stylized, _STYLIZED, Blinn_Phong, _BLINNPHONG)] _enum_specular ("Shading Mode", float) = 1
        [SubToggle(Specular._GGX._STYLIZED._BLINNPHONG._KAJIYAHAIR, _SPECULARMASK)] _SpecularMask("Use Specular Mask", Float) = 0.0
        [Channel(Specular._SPECULARMASK)] _SpecularIntensityChannel("Specular Intensity Channel", Vector) = (1,0,0,0)
        [Sub(Specular._GGX._STYLIZED._BLINNPHONG._KAJIYAHAIR)][HDR] _SpecularColor ("Specular Color", Color) = (1,1,1,1)
        [Sub(Specular._STYLIZED)] _StylizedSpecularSize ("Stylized Specular Size", Range(0,1)) = 0.1
        [Sub(Specular._STYLIZED)] _StylizedSpecularSoftness ("Stylized Specular Softness", Range(0.001,1)) = 0.05
        [Sub(Specular._STYLIZED)] _StylizedSpecularAlbedoWeight ("Specular Color Albedo Weight", Range(0,1)) = 0
        [Sub(Specular._BLINNPHONG)] _Shininess ("BlinnPhong Shininess", Range(0,1)) = 1
        [SubToggle(Specular._GGX, _SPECULARAA)] _SpecularAA("Use Specular AA", Float) = 0.0
        [Sub(Specular._SPECULARAA)] _SpaceScreenVariant ("SpecularAA Variant", Range(0,1)) = 0.5
        [Sub(Specular._SPECULARAA)] _SpecularAAThreshold ("SpecularAA Threshold", Range(0,1)) = 1
        
        [Main(Environment, _, off, off)]
        _groupEnvironment ("EnvironmentSettings", float) = 1
        [Space()]
        [KWEnum(Environment, None, _, RenderSetting, _RENDERENVSETTING, CustomCube, _CUSTOMENVCUBE)] _enum_env ("Environment Source", float) = 1
        
        [Main(EmssionSetting, _, off, off)]
        _groupEmission ("Emission Setting", float) = 0
        [Space()]
        [SubToggle(EmssionSetting, _USEEMISSIONTEX)] _UseEmissionTex("Use Emission Tex", Float) = 0.0
        [Tex(EmssionSetting._USEEMISSIONTEX)] _EmissionTex ("Emission Tex", 2D) = "white" { }
        [Channel(EmssionSetting)] _EmissionChannel("Emission Channel", Vector) = (0,0,1,0)
        [Sub(EmssionSetting)] [HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
        [Sub(EmssionSetting)] _EmissionColorAlbedoWeight("Emission Color Albedo Weight", Range(0, 1)) = 0
        
        [Main(Rim, _, off, off)]
        _groupRim ("RimSettings", float) = 1
        [Space()]
        [KWEnum(Rim, None, _, FresnelRim, _FRESNELRIM, ScreenSpaceRim, _SCREENSPACERIM)] _enum_rim ("Rim Mode", float) = 0
        [Sub(Rim._FRESNELRIM._SCREENSPACERIM)] _RimDirectionLightContribution("Directional Light Contribution", Range(0,1)) = 1.0
        [Sub(Rim._FRESNELRIM._SCREENSPACERIM)][HDR] _RimColor("Rim Color",Color) = (1,1,1,1)
        [Sub(Rim._FRESNELRIM)] _RimThreshold("Rim Threshold",Range(0,1)) = 0.2
        [Sub(Rim._FRESNELRIM)] _RimSoftness("Rim Softness",Range(0.001,1)) = 0.01
        [SubToggle(Rim._SCREENSPACERIM)] _DepthOffsetRimReverseX("Depth Offset Reverse X", Float) = 0
        [Sub(Rim._SCREENSPACERIM)] _DepthRimOffset("Depth Rim Offset",Range(-1,1)) = 0.01
        [Sub(Rim._SCREENSPACERIM)] _DepthRimThresoldOffset("Depth Rim Thresold Offset",Range(-1,1)) = 0.01
        
        [Main(ClearCoat, _, off, off)]
        _groupClearCoat ("ClearCoatSettings", float) = 1
        [Space()]
        [SubToggle(ClearCoat, _CLEARCOAT)] _ClearCoat("Use Clear Coat", Float) = 0.0
        [KWEnum(ClearCoat._CLEARCOAT, RenderSetting, _, MaterialCustom, _CUSTOMCLEARCOATTEX)] _ClearCoatTexSource ("Clear Coat Texture Source", float) = 0
        [Sub(ClearCoat._CLEARCOAT)] _ClearCoatMask("Clear Coat Mask", Range(0,1)) = 1.0
        [Sub(ClearCoat._CLEARCOAT)] _ClearCoatSmoothness("Clear Coat Smoothness", Range(0,1)) = 1.0
        
        [Main(ShadowSetting, _, off, off)]
        _groupShadowSetting ("Shadow Setting", float) = 1
        [Space()]
        [SubToggleOff(ShadowSetting, _RECEIVE_SHADOWS_OFF)] _RECEIVE_SHADOWS_OFF("RECEIVE_SHADOWS", Float) = 1
        [SubToggle(ShadowSetting, _DEPTHSHADOW)] _UseDepthShadow("Use Depth Shadow", Float) = 0.0
        [SubToggle(ShadowSetting._DEPTHSHADOW)] _DepthOffsetShadowReverseX("Depth Offset Reverse X", Float) = 0
        [Sub(ShadowSetting._DEPTHSHADOW)] _DepthShadowOffset("Depth Shadow Offset", Range(-2,2)) = 0.15
        [Sub(ShadowSetting._DEPTHSHADOW)] _DepthShadowThresoldOffset("Depth Shadow Thresold Offset", Range(-1,1)) = 0.0
        [Sub(ShadowSetting._DEPTHSHADOW)] _DepthShadowSoftness("Depth Shadow Softness", Range(0,1)) = 0.0
        
        [Main(AdditionalLightSetting, _, off, off)]
        _groupAdditionLight ("AdditionalLightSetting", float) = 1
        [Space()]
        [SubToggle(AdditionalLightSetting)] _Is_Filter_LightColor("Is Filter LightColor", Float) = 1
        [Sub(AdditionalLightSetting)] _LightIntensityClamp("Additional Light Intensity Clamp", Range(0, 8)) = 1
        
        [Main(Outline, _, off, off)]
        _groupOutline ("OutlineSettings", float) = 1
        [Space()]
        [SubToggle(Outline, _OUTLINE)] _Outline("Use Outline", Float) = 0.0
        [Sub(Outline._OUTLINE)] _OutlineColor ("Outline Color", Color) = (0,0,0,0)
        [Sub(Outline._OUTLINE)] _OutlineWidth ("Outline Width", Range(0, 10)) = 1

        // RenderSetting    
        [Title(_, RenderSetting)]
        [Surface(_)] _Surface("Surface Type", Float) = 0.0
        [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull Mode", Float) = 2.0
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Alpha", Float) = 1.0
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Alpha", Float) = 0.0
        [Enum(Off, 0, On, 1)] _ZWrite("Z Write", Float) = 1.0
        _Cutoff("Alpha Clipping", Range(0.0, 1.0)) = 0.5
        [Queue(_)] _QueueOffset("Queue offset", Range(-50, 50)) = 0.0
    }

    SubShader
    {
        Tags{"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "NPRLit" "IgnoreProjector" = "True"}
        LOD 300

        Pass
        {
            Name "ForwardLit"
            Tags{"LightMode" = "UniversalForward"}

            Blend[_SrcBlend][_DstBlend]
            ZWrite[_ZWrite]
            Cull[_Cull]

            HLSLPROGRAM
            #pragma only_renderers gles gles3 glcore d3d11
            #pragma target 3.0

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _RECEIVE_SHADOWS_OFF
            #pragma shader_feature_local _DEPTHSHADOW
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local _LAMBERTIAN _CELLSHADING _RAMPSHADING _CELLBANDSHADING
            #pragma shader_feature_local _USERAMPMAPCHANNEL
            #pragma shader_feature_local _ADDRAMPSHADING
            #pragma shader_feature_local _ _GGX _STYLIZED _BLINNPHONG
            #pragma shader_feature_local _SPECULARAA
            #pragma shader_feature_local _SPECULARMASK
            #pragma shader_feature_local _ _FRESNELRIM _SCREENSPACERIM
            #pragma shader_feature_local _CLEARCOAT
            #pragma shader_feature_local _CUSTOMCLEARCOATTEX
            #pragma shader_feature_local _ _RENDERENVSETTING _CUSTOMENVCUBE
            #pragma shader_feature_local _MATCAP
            #pragma shader_feature_local _USEEMISSIONTEX
            
            // -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _LIGHT_COOKIES
            #pragma multi_compile _ _CLUSTERED_RENDERING

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma multi_compile_fragment _ DEBUG_DISPLAY

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #pragma vertex LitPassVertex
            #pragma fragment LitPassFragment

            #include "NPRStandardInput.hlsl"
            #include "NPRStandardForwardPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma only_renderers gles gles3 glcore d3d11
            #pragma target 3.0

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON

            // -------------------------------------
            // Universal Pipeline keywords

            // This is used during shadow map generation to differentiate between directional and punctual light shadows, as they use different formulas to apply Normal Bias
            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "NPRStandardInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }
        
        Pass
        {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite On
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma only_renderers gles gles3 glcore d3d11
            #pragma target 3.0

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            #include "NPRStandardInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
            ENDHLSL
        }

        // This pass is used when drawing to a _CameraNormalsTexture texture
        Pass
        {
            Name "DepthNormals"
            Tags{"LightMode" = "DepthNormals"}

            ZWrite On
            Cull[_Cull]

            HLSLPROGRAM
            #pragma only_renderers gles gles3 glcore d3d11
            #pragma target 3.0

            #pragma vertex DepthNormalsVertex
            #pragma fragment DepthNormalsFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local _PARALLAXMAP
            #pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #include "NPRStandardInput.hlsl"
            #include "NPRDepthNormalsPass.hlsl"
            ENDHLSL
        }
        
        // This pass it not used during regular rendering, only for lightmap baking.
        Pass
        {
            Name "Meta"
            Tags{"LightMode" = "Meta"}

            Cull Off

            HLSLPROGRAM
            #pragma only_renderers gles gles3 glcore d3d11
            #pragma target 3.0

            #pragma vertex UniversalVertexMeta
            #pragma fragment UniversalFragmentMetaLit

            #pragma shader_feature EDITOR_VISUALIZATION
            #pragma shader_feature_local_fragment _SPECULAR_SETUP
            #pragma shader_feature_local_fragment _EMISSION
            #pragma shader_feature_local_fragment _METALLICSPECGLOSSMAP
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED

            #pragma shader_feature_local_fragment _SPECGLOSSMAP

            #include "NPRStandardInput.hlsl"
            #include "NPRMetaPass.hlsl"

            ENDHLSL
        }
        
        // Normal Outline
        Pass
        {
            Name "OutLine"
            Tags {"LightMode" = "Outline" }
            Cull Front
            ZWrite[_ZWrite]
            BlendOp Add, Max
            ZTest LEqual
            Offset 1, 1

            HLSLPROGRAM
            #pragma multi_compile _ _OUTLINE
            #pragma vertex NormalOutLineVertex
            #pragma fragment NormalOutlineFragment

            #include "NPRStandardInput.hlsl"
            #include "../ShaderLibrary/NormalOutline.hlsl"
            ENDHLSL
        }
        
        Pass
        {
            // Lightmode matches the ShaderPassName set in UniversalRenderPipeline.cs. SRPDefaultUnlit and passes with
            // no LightMode tag are also rendered by Universal Render Pipeline
            Name "GBuffer"
            Tags{"LightMode" = "UniversalGBuffer"}

            ZWrite[_ZWrite]
            ZTest LEqual
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            //#pragma shader_feature_local_fragment _ALPHAPREMULTIPLY_ON
            #pragma shader_feature_local_fragment _EMISSION
            #pragma shader_feature_local_fragment _METALLICSPECGLOSSMAP
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature_local_fragment _OCCLUSIONMAP
            #pragma shader_feature_local _PARALLAXMAP
            #pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED
            #pragma shader_feature_local _LAMBERTIAN _CELLSHADING _RAMPSHADING _CELLBANDSHADING
            #pragma shader_feature_local _USERAMPMAPCHANNEL
            #pragma shader_feature_local _ADDRAMPSHADING

            #pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF
            #pragma shader_feature_local_fragment _SPECULAR_SETUP
            #pragma shader_feature_local _RECEIVE_SHADOWS_OFF

            // -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            //#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            //#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #pragma vertex LitGBufferPassVertex
            #pragma fragment LitGBufferPassFragment

            #include "NPRStandardInput.hlsl"
            #include "NPRStandardGBufferPass.hlsl"
            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
    CustomEditor "LWGUI.LWGUI"
}
