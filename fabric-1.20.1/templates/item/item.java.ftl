<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2021, Pylo, opensource contributors
 # Copyright (C) 2020-2022, Goldorion, opensource contributors
 # 
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 # 
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 # 
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 # 
 # Additional permission for code generator templates (*.ftl files)
 # 
 # As a special exception, you may create a larger work that contains part or 
 # all of the MCreator code generator templates (*.ftl files) and distribute 
 # that work under terms of your choice, so long as that work isn't itself a 
 # template for code generation. Alternatively, if you modify or redistribute 
 # the template itself, you may (at your option) remove this special exception, 
 # which will cause the template and the resulting code generator output files 
 # to be licensed under the GNU General Public License without this special 
 # exception.
-->

<#-- @formatter:off -->
<#include "../procedures.java.ftl">
<#include "../mcitems.ftl">
<#include "../triggers.java.ftl">

package ${package}.item;

import net.minecraft.world.entity.ai.attributes.Attributes;
import com.google.common.collect.Multimap;

public class ${name}Item extends Item <#if hasProcedure(data.onEntitySwing)>implements EntitySwingListenerItem</#if> {

	public ${name}Item() {
		super(new Item.Properties()
				.tab(${data.creativeTab})
				<#if data.hasInventory()>
					.stacksTo(1)
				<#elseif data.damageCount != 0>
					.durability(${data.damageCount})
				<#else>
					.stacksTo(${data.stackSize})
				</#if>
				<#if data.immuneToFire>
					.fireResistant()
				</#if>
				.rarity(Rarity.${data.rarity})
				<#if data.isFood>
					.food((new FoodProperties.Builder())
						.nutrition(${data.nutritionalValue})
						.saturationMod(${data.saturation}f)
						<#if data.isAlwaysEdible>.alwaysEat()</#if>
						<#if data.isMeat>.meat()</#if>
						.build())
				</#if>
		);
	}

	<#if data.hasNonDefaultAnimation()>
		@Override public UseAnim getUseAnimation(ItemStack itemstack) {
			return UseAnim.${data.animation?upper_case};
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

	<#if data.enchantability != 0>
		@Override public int getEnchantmentValue() {
			return ${data.enchantability};
		}
	</#if>

	@Override public int getUseDuration(ItemStack itemstack) {
		return ${data.useDuration};
	}

	<#if data.toolType != 1>
		@Override public float getDestroySpeed(ItemStack par1ItemStack, BlockState par2Block) {
			return ${data.toolType}F;
		}
	</#if>

	<#if data.enableMeleeDamage>
		@Override public Multimap<Attribute, AttributeModifier> getDefaultAttributeModifiers(EquipmentSlot equipmentSlot) {
			if (equipmentSlot == EquipmentSlot.MAINHAND) {
				ImmutableMultimap.Builder<Attribute, AttributeModifier> builder = ImmutableMultimap.builder();
				builder.putAll(super.getDefaultAttributeModifiers(equipmentSlot));
				builder.put(Attributes.ATTACK_DAMAGE, new AttributeModifier(BASE_ATTACK_DAMAGE_UUID, "Item modifier", ${data.damageVsEntity - 2}d, AttributeModifier.Operation.ADDITION));
				builder.put(Attributes.ATTACK_SPEED, new AttributeModifier(BASE_ATTACK_SPEED_UUID, "Item modifier", -2.4, AttributeModifier.Operation.ADDITION));
			}
			return super.getDefaultAttributeModifiers(equipmentSlot);
		}
	</#if>

	<#if data.hasGlow>
		@Override public boolean isFoil(ItemStack itemstack) {
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

	<#if data.destroyAnyBlock>
		@Override public boolean isCorrectToolForDrops(BlockState state) {
			return true;
		}
	</#if>

	<#if data.specialInfo?has_content>
		@Override public void appendHoverText(ItemStack itemstack, Level world, List<Component> list, TooltipFlag flag) {
			super.appendHoverText(itemstack, world, list, flag);
			<#list data.specialInfo as entry>
			list.add(Component.literal("${JavaConventions.escapeStringForJava(entry)}"));
			</#list>
		}
	</#if>

	<#if hasProcedure(data.onRightClickedInAir) || data.hasInventory()>
		@Override public InteractionResultHolder<ItemStack> use(Level world, Player entity, InteractionHand hand) {
			InteractionResultHolder<ItemStack> ar = super.use(world, entity, hand);
			ItemStack itemstack = ar.getObject();
			double x = entity.getX();
			double y = entity.getY();
			double z = entity.getZ();

			<#if data.hasInventory()>
				entity.openMenu(new ExtendedScreenHandlerFactory() {
					@Override
					public AbstractContainerMenu createMenu(int syncId, Inventory inventory, Player player) {
						return new ${data.guiBoundTo}Menu(syncId, inventory, new ${name}Inventory(itemstack));
					}

					@Override
					public Component getDisplayName() {
						return itemstack.getDisplayName();
					}

					@Override
					public void writeScreenOpeningData(ServerPlayer player, FriendlyByteBuf buf) {
						buf.writeBlockPos(BlockPos.ZERO);
					}
				});
			</#if>

			<@procedureOBJToCode data.onRightClickedInAir/>
			return ar;
		}
	</#if>

	<#if hasProcedure(data.onFinishUsingItem) || data.hasEatResultItem()>
		@Override public ItemStack finishUsingItem(ItemStack itemstack, Level world, LivingEntity entity) {
			ItemStack retval =
				<#if data.hasEatResultItem()>
					${mappedMCItemToItemStackCode(data.eatResultItem, 1)};
				</#if>
			super.finishUsingItem(itemstack, world, entity);

			<#if hasProcedure(data.onFinishUsingItem)>
				double x = entity.getX();
				double y = entity.getY();
				double z = entity.getZ();
				<@procedureOBJToCode data.onFinishUsingItem/>
			</#if>

			<#if data.hasEatResultItem()>
				if (itemstack.isEmpty()) {
					return retval;
				} else {
					if (entity instanceof Player player && !player.getAbilities().instabuild) {
						if (!player.getInventory().add(retval))
							player.drop(retval, false);
					}
					return itemstack;
				}
			<#else>
				return retval;
			</#if>
		}
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

	<@onEntityHitWith data.onEntityHitWith/>

	<@onCrafted data.onCrafted/>

	<@onStoppedUsing data.onStoppedUsing/>

	<@onItemTick data.onItemInUseTick, data.onItemInInventoryTick/>

}
<#-- @formatter:on -->