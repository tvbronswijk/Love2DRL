
function inv_reg()
    bitser.register("inv_conf", invoke_confusion)
    bitser.register("inv_str", invoke_strength)
    bitser.register("inv_regen", invoke_regen)
    bitser.register("inv_vamp", invoke_vampirism)
end

function add_invocation(target, duration, invoke_function)
    local inv = Invocation(duration, invoke_function)
    if target.fighter then 
        inv.owner = target.fighter
        table.insert(target.fighter.invocations, inv)
    end
end

function invoke_confusion(self, state)
    if self.old_ai == nil and state then
        self.old_ai = self.owner.owner.ai
        new_ai = ConfusedMonster()
        new_ai.owner = self.owner.owner 
        self.owner.owner.ai = new_ai
    elseif not state then
        game.console.print("The confusion has ended.", color_green)
        self.owner.owner.ai = self.old_ai
        table.remove(self.owner.invocations, table.index_of(self.owner.invocations, self))
    end
end

function invoke_strength(self, state)
    if not self.fired and state then
        self.old_pwr = self.owner.base_power
        new_pwr = self.owner.base_power + 5
        self.owner.base_power = new_pwr
        self.fired = true
    elseif not state then
        game.console.print(invocation.owner.owner.name .. " no longer feels powerful.", color_player)
        self.owner.base_power = self.old_pwr
        table.remove(invocation.owner.invocations, table.index_of(self.owner.invocations, self))
    end
end

function invoke_regen(self, state)
    if state then
        self.owner:heal(5)
        game.console.print(self.owner.owner.name .. " feels a little better!", color_player)
    elseif not state then
        table.remove(self.owner.invocations, table.index_of(self.owner.invocations, self))
    end
end

function invoke_vampirism(self, state)
    if state then
        self.owner.base_defense = 30
        self.owner.base_power = 30
        self.owner.base_max_hp = 5
        self.owner.hp = 5
        if self.weakness then
            self.owner.death_function(self.owner)
        end
    elseif not state then
        table.remove(self.owner.invocations, table.index_of(self.owner.invocations, self))
    end
end
