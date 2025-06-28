package models;

import java.util.List;

public class ShiftDisplay {
    private Shift shift;
    private List<String> weekDays;

    public ShiftDisplay(Shift shift, List<String> weekDays) {
        this.shift = shift;
        this.weekDays = weekDays;
    }

    public Shift getShift() {
        return shift;
    }

    public void setShift(Shift shift) {
        this.shift = shift;
    }

    public List<String> getWeekDays() {
        return weekDays;
    }

    public void setWeekDays(List<String> weekDays) {
        this.weekDays = weekDays;
    }
} 