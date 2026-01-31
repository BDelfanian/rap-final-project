import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

def plot_seaborn_box(data: pd.DataFrame) -> plt.Figure:
    """Seaborn boxplot of iris measurements by species"""
    df_melt = pd.melt(data, id_vars=['Species'], value_vars=data.select_dtypes(include='number').columns,
                      var_name='measurement', value_name='value')
    
    fig, ax = plt.subplots(figsize=(10, 6))
    sns.boxplot(data=df_melt, x='Species', y='value', hue='measurement', ax=ax)
    ax.set_title('Iris Measurements by Species (Seaborn)')
    plt.tight_layout()
    return fig