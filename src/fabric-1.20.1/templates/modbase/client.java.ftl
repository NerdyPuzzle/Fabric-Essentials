<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2020-2022, Goldorion, opensource contributors
 #
 # Fabric-Generator-MCreator is free software: you can redistribute it and/or modify
 # it under the terms of the GNU Lesser General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.

 # Fabric-Generator-MCreator is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 # GNU Lesser General Public License for more details.
 #
 # You should have received a copy of the GNU Lesser General Public License
 # along with Fabric-Generator-MCreator.  If not, see <https://www.gnu.org/licenses/>.
-->

<#-- @formatter:off -->
/*
*	MCreator note:
*
*	If you lock base mod element files, you can edit this file and the proxy files
*	and they won't get overwritten. If you change your mod package or modid, you
*	need to apply these changes to this file MANUALLY.
*
*
*	If you do not lock base mod element files in Workspace settings, this file
*	will be REGENERATED on each build.
*
*/

package ${package};
import net.fabricmc.api.Environment;

@Environment(EnvType.CLIENT) public class ClientInit implements ClientModInitializer {

	@Override
	public void onInitializeClient(){
		<#if w.hasElementsOfType("keybind")>${JavaModName}KeyMappings.load();</#if>
		<#if w.hasElementsOfType("particle")>${JavaModName}ParticleTypes.load();</#if>
		<#if w.hasElementsOfType("overlay")>${JavaModName}Overlays.load();</#if>
		<#if w.hasElementsOfBaseType("block")>${JavaModName}Blocks.clientLoad();</#if>
		<#if w.hasElementsOfType("gui")>${JavaModName}Screens.load();</#if>
		<#if w.hasJavaModels()>${JavaModName}Models.load();</#if>
		<#if w.hasElementsOfBaseType("entity")>${JavaModName}EntityRenderers.load();</#if>
		ClientPlayConnectionEvents.JOIN.register((handler, sender, client) -> {
			if (client.player.getExtraCustomData().getCompound("PlayerPersisted").isEmpty()) {
				client.player.getExtraCustomData().put("PlayerPersisted", new CompoundTag());
			}
		});

	}
}

<#-- @formatter:on -->
