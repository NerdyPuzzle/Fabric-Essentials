<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2021, Pylo, opensource contributors
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
<#include "mcitems.ftl">
<#include "procedures.java.ftl">
<#include "triggers.java.ftl">

package ${package}.item;

import com.google.common.collect.Multimap;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.fabricmc.api.Environment;

<#compress>
<#if data.toolType == "Pickaxe" || data.toolType == "Axe" || data.toolType == "Sword" || data.toolType == "Spade"
		|| data.toolType == "Hoe" || data.toolType == "Shears" || data.toolType == "MultiTool">
public class ${name}Item extends ${data.toolType?replace("Spade", "Shovel")?replace("MultiTool", "Tiered")}Item <#if hasProcedure(data.onEntitySwing)>implements EntitySwingListenerItem</#if> {
	public ${name}Item () {
		super(<#if data.toolType == "Pickaxe" || data.toolType == "Axe" || data.toolType == "Sword"
				|| data.toolType == "Spade" || data.toolType == "Hoe" || data.toolType == "MultiTool">
			new Tier() {
				public int getUses() {
					return ${data.usageCount};
				}

   				public float getSpeed() {
					return ${data.efficiency}f;
				}

   				public float getAttackDamageBonus() {
					return ${data.damageVsEntity - 2}f;
				}

   				public int getLevel() {
					return ${data.harvestLevel};
				}

   				public int getEnchantmentValue() {
					return ${data.enchantability};
				}

   				public Ingredient getRepairIngredient() {
					<#if data.repairItems?has_content>
					return Ingredient.of(
							<#list data.repairItems as repairItem>
							${mappedMCItemToItemStackCode(repairItem,1)}<#if repairItem?has_next>,</#if>
					</#list>
							);
					<#else>
					return Ingredient.EMPTY;
					</#if>
				}
			},

			<#if data.toolType!="MultiTool">
				<#if data.toolType=="Sword">3<#elseif data.toolType=="Hoe">0<#else>1</#if>,${data.attackSpeed - 4}f,
			</#if>

				new Item.Properties()
			 	.tab(${data.creativeTab})
			 	<#if data.immuneToFire>
			 	    .fireResistant()
			 	</#if>
		<#elseif data.toolType=="Shears">
			new Item.Properties()
				.tab(${data.creativeTab})
				.durability(${data.usageCount})
				<#if data.immuneToFire>
                    .fireResistant()
				</#if>
		</#if>);
	}

	<#if data.toolType=="Shears">
		@Override public int getEnchantmentValue() {
			return ${data.enchantability};
		}

		@Override public float getDestroySpeed(ItemStack stack, BlockState blockstate) {
			return ${data.efficiency}f;
		}
	<#elseif data.toolType=="MultiTool">
		@Override public boolean isCorrectToolForDrops(BlockState blockstate) {
			int tier = ${data.harvestLevel};
			if (tier < 3 && blockstate.is(BlockTags.NEEDS_DIAMOND_TOOL)) {
				return false;
			} else if (tier < 2 && blockstate.is(BlockTags.NEEDS_IRON_TOOL)) {
				return false;
			} else {
				return tier < 1 && blockstate.is(BlockTags.NEEDS_STONE_TOOL) ? false : (
								blockstate.is(BlockTags.MINEABLE_WITH_AXE) ||
								blockstate.is(BlockTags.MINEABLE_WITH_HOE) ||
								blockstate.is(BlockTags.MINEABLE_WITH_PICKAXE) ||
								blockstate.is(BlockTags.MINEABLE_WITH_SHOVEL)
						);
			}
		}

		@Override public float getDestroySpeed(ItemStack itemstack, BlockState blockstate) {
			return ${data.efficiency}f;
		}

		@Override public Multimap<Attribute, AttributeModifier> getDefaultAttributeModifiers(EquipmentSlot equipmentSlot) {
			if (equipmentSlot == EquipmentSlot.MAINHAND) {
				ImmutableMultimap.Builder<Attribute, AttributeModifier> builder = ImmutableMultimap.builder();
				builder.putAll(super.getDefaultAttributeModifiers(equipmentSlot));
				builder.put(Attributes.ATTACK_DAMAGE, new AttributeModifier(BASE_ATTACK_DAMAGE_UUID, "Tool modifier", ${data.damageVsEntity - 2}f, AttributeModifier.Operation.ADDITION));
				builder.put(Attributes.ATTACK_SPEED, new AttributeModifier(BASE_ATTACK_SPEED_UUID, "Tool modifier", ${data.attackSpeed - 4}, AttributeModifier.Operation.ADDITION));
				return builder.build();
			}

			return super.getDefaultAttributeModifiers(equipmentSlot);
		}
	</#if>

	<#if data.toolType=="MultiTool">
		@Override public boolean hurtEnemy(ItemStack stack, LivingEntity entity, LivingEntity sourceentity) {
			stack.hurtAndBreak(2, sourceentity, i -> i.broadcastBreakEvent(EquipmentSlot.MAINHAND));
			<#if hasProcedure(data.onEntityHitWith)>
				double x = entity.getX();
				double y = entity.getY();
				double z = entity.getZ();
				Level world = entity.level;
				<@procedureOBJToCode data.onEntityHitWith/>
			</#if>
			return true;
		}

		@Override public boolean mineBlock(ItemStack stack, Level world, BlockState state, BlockPos pos, LivingEntity entity) {
			stack.hurtAndBreak(1, entity, i -> i.broadcastBreakEvent(EquipmentSlot.MAINHAND));
			<#if hasProcedure(data.onBlockDestroyedWithTool)>
				int x = pos.getX();
				int y = pos.getY();
				int z = pos.getZ();
				<@procedureOBJToCode data.onBlockDestroyedWithTool/>
			</#if>
			return true;
		}
	<#else>
		<#if hasProcedure(data.onBlockDestroyedWithTool)>
		@Override public boolean mineBlock(ItemStack itemstack, Level world, BlockState blockstate, BlockPos pos, LivingEntity entity){
			boolean retval = super.mineBlock(itemstack, world, blockstate, pos, entity);
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			<@procedureOBJToCode data.onBlockDestroyedWithTool/>
			return retval;
		}
		</#if>

		<#if hasProcedure(data.onEntityHitWith)>
		@Override public boolean hurtEnemy(ItemStack itemstack, LivingEntity entity, LivingEntity sourceentity) {
			boolean retval = super.hurtEnemy(itemstack, entity, sourceentity);
			double x = entity.getX();
			double y = entity.getY();
			double z = entity.getZ();
			Level world = entity.level;
			<@procedureOBJToCode data.onEntityHitWith/>
			return retval;
		}
		</#if>
	</#if>

	<@onRightClickedInAir data.onRightClickedInAir/>

	<@commonMethods/>

}
<#elseif data.toolType=="Special">
public class ${name}Item extends Item <#if hasProcedure(data.onEntitySwing)>implements EntitySwingListenerItem</#if> {

	public ${name}Item() {
		super(new Item.Properties()
			.tab(${data.creativeTab})
			.durability(${data.usageCount})
			<#if data.immuneToFire>
			.fireResistant()
			</#if>
		);
	}

	@Override public float getDestroySpeed(ItemStack itemstack, BlockState blockstate) {
		return List.of(
			<#list data.blocksAffected as restrictionBlock>
			${mappedBlockToBlock(restrictionBlock)}<#if restrictionBlock?has_next>,</#if>
			</#list>
		).contains(blockstate.getBlock()) ? ${data.efficiency}f : 1;
	}

	@Override public boolean mineBlock(ItemStack stack, Level world, BlockState state, BlockPos pos, LivingEntity entity) {
		stack.hurtAndBreak(1, entity, i -> i.broadcastBreakEvent(EquipmentSlot.MAINHAND));
		<#if hasProcedure(data.onBlockDestroyedWithTool)>
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			<@procedureOBJToCode data.onBlockDestroyedWithTool/>
		</#if>
		return true;
	}

	@Override public boolean hurtEnemy(ItemStack stack, LivingEntity entity, LivingEntity sourceentity) {
		stack.hurtAndBreak(2, sourceentity, i -> i.broadcastBreakEvent(EquipmentSlot.MAINHAND));
		<#if hasProcedure(data.onEntityHitWith)>
			double x = entity.getX();
			double y = entity.getY();
			double z = entity.getZ();
			Level world = entity.level;
			<@procedureOBJToCode data.onEntityHitWith/>
		</#if>
		return true;
	}
	
	<@onRightClickedInAir data.onRightClickedInAir/>

	@Override public int getEnchantmentValue() {
		return ${data.enchantability};
	}

	@Override public Multimap<Attribute, AttributeModifier> getDefaultAttributeModifiers(EquipmentSlot equipmentSlot) {
		if (equipmentSlot == EquipmentSlot.MAINHAND) {
			ImmutableMultimap.Builder<Attribute, AttributeModifier> builder = ImmutableMultimap.builder();
			builder.putAll(super.getDefaultAttributeModifiers(equipmentSlot));
			builder.put(Attributes.ATTACK_DAMAGE, new AttributeModifier(BASE_ATTACK_DAMAGE_UUID, "Tool modifier", ${data.damageVsEntity - 2}f, AttributeModifier.Operation.ADDITION));
			builder.put(Attributes.ATTACK_SPEED, new AttributeModifier(BASE_ATTACK_SPEED_UUID, "Tool modifier", ${data.attackSpeed - 4}, AttributeModifier.Operation.ADDITION));
			return builder.build();
		}

   	   return super.getDefaultAttributeModifiers(equipmentSlot);
   	}

	<@commonMethods/>
}
<#elseif data.toolType=="Fishing rod">
public class ${name}Item extends FishingRodItem <#if hasProcedure(data.onEntitySwing)>implements EntitySwingListenerItem</#if> {

	public ${name}Item() {
		super(new Item.Properties()
			.tab(${data.creativeTab})
			.durability(${data.usageCount})
			<#if data.immuneToFire>
			.fireResistant()
			</#if>
		);
	}

	<#if data.repairItems?has_content>
	@Override public boolean isValidRepairItem(ItemStack itemstack, ItemStack repairitem) {
		return List.of(
			<#list data.repairItems as repairItem>
				${mappedMCItemToItem(repairItem)}<#if repairItem?has_next>,</#if>
			</#list>
		).contains(repairitem.getItem());
	}
	</#if>

	@Override public int getEnchantmentValue() {
		return ${data.enchantability};
	}

	<#if hasProcedure(data.onBlockDestroyedWithTool)>
		@Override public boolean mineBlock(ItemStack itemstack, Level world, BlockState blockstate, BlockPos pos, LivingEntity entity){
			boolean retval = super.mineBlock(itemstack,world,blockstate,pos,entity);
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			<@procedureOBJToCode data.onBlockDestroyedWithTool/>
			return retval;
		}
	</#if>

	<@onEntityHitWith data.onEntityHitWith/>

	@Override public InteractionResultHolder<ItemStack> use(Level world, Player entity, InteractionHand hand) {
		ItemStack itemstack = entity.getItemInHand(hand);
		if (entity.fishing != null) {
			if (!world.isClientSide()) {
				itemstack.hurtAndBreak(entity.fishing.retrieve(itemstack), entity, i -> i.broadcastBreakEvent(hand));
			}
			world.playSound(null, entity.getX(), entity.getY(), entity.getZ(), SoundEvents.FISHING_BOBBER_RETRIEVE, SoundSource.NEUTRAL, 1, 0.4f / (world.getRandom().nextFloat() * 0.4f + 0.8f));
			entity.gameEvent(GameEvent.ITEM_INTERACT_FINISH);
		} else {
			world.playSound(null, entity.getX(), entity.getY(), entity.getZ(), SoundEvents.FISHING_BOBBER_THROW, SoundSource.NEUTRAL, 0.5f, 0.4f / (world.getRandom().nextFloat() * 0.4f + 0.8f));
			if (!world.isClientSide()) {
				int k = EnchantmentHelper.getFishingSpeedBonus(itemstack);
				int j = EnchantmentHelper.getFishingLuckBonus(itemstack);
				world.addFreshEntity(new FishingHook(entity, world, j, k));
			}

			entity.awardStat(Stats.ITEM_USED.get(this));
			entity.gameEvent(GameEvent.ITEM_INTERACT_FINISH);
		}
		
		<#if hasProcedure(data.onRightClickedInAir)>
		double x = entity.getX();
		double y = entity.getY();
		double z = entity.getZ();
		<@procedureOBJToCode data.onRightClickedInAir/>
		</#if>

		return InteractionResultHolder.sidedSuccess(itemstack, world.isClientSide());
	}

	<@commonMethods/>
}
</#if>

<#macro commonMethods>
	<#if data.specialInfo?has_content>
		@Override @Environment(EnvType.CLIENT) public void appendHoverText(ItemStack itemstack, Level world, List<Component> list, TooltipFlag flag) {
			super.appendHoverText(itemstack, world, list, flag);
			<#list data.specialInfo as entry>
			list.add(Component.literal("${JavaConventions.escapeStringForJava(entry)}"));
			</#list>
		}
	</#if>

	<#if data.stayInGridWhenCrafting>
		@Override public boolean hasCraftingRemainingItem() {
			return true;
		}

		<#if data.recipeRemainder?? && !data.recipeRemainder.isEmpty()>
			@Override public ItemStack getRecipeRemainder(ItemStack itemstack) {
			    return ${mappedMCItemToItemStackCode(data.recipeRemainder, 1)};
        	}
		<#elseif data.damageOnCrafting && data.damageCount != 0>
			@Override public ItemStack getRecipeRemainder(ItemStack itemstack) {
				ItemStack retval = new ItemStack(this);
				retval.setDamageValue(itemstack.getDamageValue() + 1);
				if(retval.getDamageValue() >= retval.getMaxDamage()) {
					return ItemStack.EMPTY;
				}
				return retval;
			}
		<#else>
			@Override public ItemStack getRecipeRemainder(ItemStack itemstack) {
				return new ItemStack(this);
			}
		</#if>
	</#if>
	
	<#if hasProcedure(data.onEntitySwing)>
	public boolean onEntitySwing(ItemStack itemstack, LivingEntity entity) {
		double x = entity.getX();
		double y = entity.getY();
		double z = entity.getZ();
		LevelAccessor world = entity.level;
		<@procedureOBJToCode data.onEntitySwing/>
		return false;
	}
	</#if>

	<@onItemUsedOnBlock data.onRightClickedOnBlock/>

	<@onCrafted data.onCrafted/>

	<@onStoppedUsing data.onStoppedUsing/>

	<@onItemTick data.onItemInUseTick, data.onItemInInventoryTick/>

	<#if data.hasGlow>
		@Override @Environment(EnvType.CLIENT) public boolean isFoil(ItemStack itemstack) {
			<#if hasProcedure(data.glowCondition)>
			Player entity = Minecraft.getInstance().player;
			Level world = entity.level;
			double x = entity.getX();
			double y = entity.getY();
			double z = entity.getZ();
			return <@procedureOBJToConditionCode data.glowCondition/>;
			<#else>
			return true;
			</#if>
		}
	</#if>
</#macro>
</#compress>
<#-- @formatter:on -->